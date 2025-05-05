package vacantes.restcontroller;

import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import jakarta.servlet.http.HttpServletRequest;
import vacantes.jwt.JwtTokenUtil;
import vacantes.modelo.dto.EmpresaAltaDto;
import vacantes.modelo.dto.EmpresaListasDto;
import vacantes.modelo.dto.EmpresaModificarDto;
import vacantes.modelo.dto.UsuarioAltaDto;
import vacantes.modelo.dto.UsuarioListasDto;
import vacantes.modelo.dto.UsuarioModificarDto;
import vacantes.modelo.entities.Categoria;
import vacantes.modelo.entities.Empresa;
import vacantes.modelo.entities.Rol;
import vacantes.modelo.entities.Solicitud;
import vacantes.modelo.entities.Usuario;
import vacantes.modelo.entities.Vacante;
import vacantes.modelo.service.CategoriaService;
import vacantes.modelo.service.EmpresaService;
import vacantes.modelo.service.SolicitudService;
import vacantes.modelo.service.UsuarioService;
import vacantes.modelo.service.VacanteService;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/api/admin")
public class AdminRestController {
	
	@Autowired
	private EmpresaService empresaService;
	
	@Autowired
	private CategoriaService categoriaService;
	
	@Autowired
	private UsuarioService usuarioService;
	
	@Autowired
	private VacanteService vacanteService;
	
	@Autowired
	private SolicitudService solicitudService;
	
	@Autowired
	private JwtTokenUtil jwtTokenUtil;
	
	@PostMapping("/altaEmpresa")
	public ResponseEntity<?> altaEmpresa(@RequestBody EmpresaAltaDto altaDto, HttpServletRequest request){
	    boolean token = isValidToken(request);

	    if (token == false) {
	        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Token JWT no válido o no proporcionado");
	    }

	    Usuario usuarioEmpresa = new Usuario();
	    usuarioEmpresa.setRol(Rol.EMPRESA);
	    usuarioEmpresa.setPassword(generarPasswordAleatoria(10));
	    usuarioEmpresa.setFechaRegistro(new Date());
	    usuarioEmpresa.setNombre(altaDto.getNombreUsuario());
	    usuarioEmpresa.setApellidos(altaDto.getApellidos());
	    usuarioEmpresa.setEmail(altaDto.getEmail());
	    usuarioService.insertUno(usuarioEmpresa);

	    Empresa empresaBuscada = new Empresa();
	    empresaBuscada.setCif(altaDto.getCif());
	    empresaBuscada.setNombreEmpresa(altaDto.getNombreEmpresa());
	    empresaBuscada.setDireccionFiscal(altaDto.getDireccionFiscal());
	    empresaBuscada.setPais(altaDto.getPais());
	    empresaBuscada.setUsuario(usuarioEmpresa);

	    if(empresaService.insertUno(empresaBuscada) == true) {
	        return new ResponseEntity<>("La empresa se ha creado con éxito", HttpStatus.CREATED);
	    }
	    else {
	        return new ResponseEntity<>("No se ha podido crear la empresa", HttpStatus.BAD_REQUEST);
	    }
	}
	
	@GetMapping("/verEmpresas")
	public ResponseEntity<?>verEmpresas(HttpServletRequest request){
		try {
			boolean token = isValidToken(request);

			if (token == false) {
				return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Token JWT no válido o no proporcionado");
			}
			
			List<Empresa> listaAux = empresaService.buscarTodo();
			
			if(!listaAux.isEmpty()) {
				List<EmpresaListasDto> empresaDto = listaAux.stream()
						.map(empresa ->{
							EmpresaListasDto dto = new EmpresaListasDto();
							return dto.convertToEmpresaListasDto(empresa);
						})
				.collect(Collectors.toList());
				
			    return new ResponseEntity<>(empresaDto, HttpStatus.OK);
			}
			
			return new ResponseEntity<>("No hay empresas", HttpStatus.NOT_FOUND);
			

		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<>("Token inválido" + e.getMessage(), HttpStatus.NOT_FOUND);
		}
	}
	
	
	@PutMapping("/modificarEmpresa/{idEmpresa}")
	public ResponseEntity<?>modificarEmpresa(@PathVariable int idEmpresa, @RequestBody EmpresaModificarDto empresaDto, HttpServletRequest request){
		try {
			boolean token = isValidToken(request);

			if (token == false) {
				return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Token JWT no válido o no proporcionado");
			}
				Empresa empresaMod = empresaService.buscarUno(idEmpresa);
				
				empresaMod.setIdEmpresa(idEmpresa);
				empresaMod.setNombreEmpresa(empresaDto.getNombre());
				empresaMod.setDireccionFiscal(empresaDto.getDireccionFiscal());
				empresaMod.setPais(empresaDto.getPais());
				
				if (empresaService.modificarUno(empresaMod) == 1) {
					return new ResponseEntity<>("La empresa se modificó correctamente", HttpStatus.OK);
				} else {
					return new ResponseEntity<>("La empresa no se ha podido modificar", HttpStatus.NOT_MODIFIED);
				}
				
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<>("Empresa no modificada" + e.getMessage(), HttpStatus.NOT_MODIFIED);
		}
	}

	
	@DeleteMapping("/eliminarEmpresa/{idEmpresa}")
	public ResponseEntity<?> eliminarEmpresa(@PathVariable int idEmpresa, HttpServletRequest request) {
	    try {
	        boolean token = isValidToken(request);

	        if (!token) {
	            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Token JWT no válido o no proporcionado");
	        }

	        List<Vacante> vacantesAsociadas = vacanteService.buscarVacantePorEmpresa(idEmpresa);

	        if (vacantesAsociadas.isEmpty()) {
	            empresaService.eliminarUno(idEmpresa);
	            return new ResponseEntity<>("Empresa eliminada correctamente", HttpStatus.OK);
	        } else {
	         
	            for (Vacante vacante : vacantesAsociadas) {
	                List<Solicitud> solicitudesAsociadas = solicitudService.buscarSolicitudPorIdVacante(vacante.getIdVacante());

	                for (Solicitud solicitud : solicitudesAsociadas) {
	                    solicitudService.eliminarUno(solicitud.getIdSolicitud());
	                }

	                vacanteService.eliminarUno(vacante.getIdVacante());
	            }

	            empresaService.eliminarUno(idEmpresa);
	            
	            return new ResponseEntity<>("Empresa, vacantes y solicitudes asociadas eliminadas correctamente", HttpStatus.OK);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        return new ResponseEntity<>("No se ha podido eliminar la empresa: " + e.getMessage(), HttpStatus.BAD_REQUEST);
	    }
	}
	
	@PostMapping("/altaCategoria")
	public ResponseEntity<?>altaCategoria(@RequestBody Categoria categoria, HttpServletRequest request){
		boolean token = isValidToken(request);

		if (token == false) {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Token JWT no válido o no proporcionado");
		}
			Categoria categoriaNueva = new Categoria();
			
			categoriaNueva.setDescripcion(categoria.getDescripcion());
			categoriaNueva.setNombre(categoria.getNombre());
			categoriaService.insertUno(categoriaNueva);
		return new ResponseEntity<>("Categoría creada con ÉXITO", HttpStatus.CREATED);
	}
	
	@GetMapping("/verCategorias")
	public ResponseEntity<?>verCategorias( HttpServletRequest request){
		try {
			boolean token = isValidToken(request);

			if (token == false) {
				return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Token JWT no válido o no proporcionado");
			}
			List<Categoria> listCat = categoriaService.buscarTodo();
			if(!listCat.isEmpty()) {
				return new ResponseEntity<>(listCat, HttpStatus.OK);

			}
			else {
				return new ResponseEntity<>("Error al ver categorías", HttpStatus.BAD_REQUEST);

			}
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<>("No hay categorias" + e.getMessage(), HttpStatus.NOT_FOUND);
		}
	}
	
	@PutMapping("/modificarCategoria/{idCategoria}")
	public ResponseEntity<?>modificarCategoria(@PathVariable int idCategoria, @RequestBody Categoria categoria, HttpServletRequest request){
		try {
			boolean token = isValidToken(request);

			if (token == false) {
				return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Token JWT no válido o no proporcionado");
			}

				categoria.setIdCategoria(idCategoria);
				if (categoriaService.modificarUno(categoria) == 1) {
					return new ResponseEntity<>("La categoria se modificó correctamente", HttpStatus.OK);
				} else {
					return new ResponseEntity<>("La categoria no se ha podido modificar", HttpStatus.NOT_MODIFIED);
				}

		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<>("No se ha podido modificar la categoria", HttpStatus.NOT_MODIFIED);
		}
	}

	@DeleteMapping("/eliminarCategoria/{idCategoria}")
	public ResponseEntity<?> eliminarCat(@PathVariable int idCategoria, HttpServletRequest request) {
	    try {
	        boolean token = isValidToken(request);

	        if (!token) {
	            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
	                    .body("Token JWT no válido o no proporcionado");
	        }

	        List<Vacante> listaVacantes = vacanteService.buscarVacantePorCategoria(idCategoria);
	        boolean tieneVacantes = !listaVacantes.isEmpty();
	        boolean tieneSolicitudes = false;

	        if (tieneVacantes) {
	            for (Vacante vacante : listaVacantes) {
	                List<Solicitud> solicitudes = solicitudService.buscarSolicitudPorIdVacante(vacante.getIdVacante());
	                if (!solicitudes.isEmpty()) {
	                    tieneSolicitudes = true;
	                    for (Solicitud solicitud : solicitudes) {
	                        solicitudService.eliminarUno(solicitud.getIdSolicitud());
	                    }
	                }
	            }

	            for (Vacante vacante : listaVacantes) {
	                vacanteService.eliminarUno(vacante.getIdVacante());
	            }
	        }

	        categoriaService.eliminarUno(idCategoria);

	        if (tieneVacantes && tieneSolicitudes) {
	            return new ResponseEntity<>("Se eliminaron la categoría, las solicitudes y las vacantes asociadas", 
	                    HttpStatus.OK);
	        } else if (tieneVacantes) {
	            return new ResponseEntity<>("Se eliminó correctamente la categoría y sus vacantes (sin solicitudes)", 
	                    HttpStatus.OK);
	        } else {
	            return new ResponseEntity<>("Se eliminó la categoría (sin vacantes ni solicitudes asociadas)", 
	                    HttpStatus.OK);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        return new ResponseEntity<>("No se ha podido eliminar la categoría: " + e.getMessage(), 
	                HttpStatus.BAD_REQUEST);
	    }
	}
 
	@PutMapping("/eliminarUsuario/{email}")
	public ResponseEntity<?>eliminarUsuario(@PathVariable String email, HttpServletRequest request){
		try {
			boolean token = isValidToken(request);

			if (token == false) {
				return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Token JWT no válido o no proporcionado");
			}
			Usuario usuarioBuscado = usuarioService.buscarUno(email);
			usuarioBuscado.setEnabled(0);
			usuarioService.modificarUno(usuarioBuscado);
			return new ResponseEntity<>("El usuario se ha eliminado correctamente", HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<>("No se ha podido eliminar la categoria" + e.getMessage(), HttpStatus.BAD_REQUEST);
		}
	}
	
	@PostMapping("/altaAdmon")
	public ResponseEntity<?> altaAdmon(@RequestBody UsuarioAltaDto altaDto, HttpServletRequest request) {
	    try {
	        boolean token = isValidToken(request);
	        if (!token) {
	            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Token JWT no válido o no proporcionado");
	        }
	        
	        Usuario usuarioBuscado = new Usuario();
	        usuarioBuscado.setEmail(altaDto.getEmail());
	        usuarioBuscado.setNombre(altaDto.getNombre());
	        usuarioBuscado.setApellidos(altaDto.getApellidos());
	        usuarioBuscado.setEnabled(1);
	        usuarioBuscado.setFechaRegistro(new Date());
	        usuarioBuscado.setPassword(generarPasswordAleatoria(10));
	        usuarioBuscado.setRol(Rol.ADMON);
	        if(usuarioService.insertUno(usuarioBuscado) == true);
	        	return new ResponseEntity<>("El usuario se creó correctamente", HttpStatus.CREATED);
	    } catch (Exception e) {
	        e.printStackTrace();
	        return new ResponseEntity<>("Error al dar de alta el usuario: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
	    }
	}
	
	@GetMapping("/verUsuarios")
	public ResponseEntity<?>verUsuarios( HttpServletRequest request){
		try {
			boolean token = isValidToken(request);

			if (token == false) {
				return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Token JWT no válido o no proporcionado");
			}
			
			List<Usuario> listUser = usuarioService.buscarTodo();
			
			if(!listUser.isEmpty()) {
				
				List<UsuarioListasDto> usuarioDto = listUser.stream()
						.map(usuario ->{
							UsuarioListasDto dto = new UsuarioListasDto();
							return dto.convertToUsuarioListasDto(usuario);
						})
						.collect(Collectors.toList());
				
			    return new ResponseEntity<>(usuarioDto, HttpStatus.OK);
			}else {
				return new ResponseEntity<>("Error al ver categorías", HttpStatus.BAD_REQUEST);

			}
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<>("No hay categorias" + e.getMessage(), HttpStatus.NOT_FOUND);
		}
	}
	
	@PutMapping("/modificarUsuario/{email}")
	public ResponseEntity<?> modificarUsuario(@PathVariable String email, @RequestBody UsuarioModificarDto usuaDto, HttpServletRequest request) {
	    try {
	        boolean token = isValidToken(request);

	        if (!token) {
	            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
	                    .body("Token JWT no válido o no proporcionado");
	        }

	        Usuario usuarioMod = usuarioService.buscarUno(email);

	        if (usuarioMod != null) {
	            usuarioMod.setEmail(email);
	            usuarioMod.setNombre(usuaDto.getNombre());
	            usuarioMod.setApellidos(usuaDto.getApellidos());
	            usuarioMod.setPassword(usuaDto.getPassword());
	            usuarioMod.setEnabled(1);
	            
	            if (usuarioService.modificarUno(usuarioMod) == 1) {
	                return new ResponseEntity<>("El usuario se modificó correctamente", HttpStatus.OK);
	            } else {
	                return new ResponseEntity<>("El usuario no se ha podido modificar", HttpStatus.NOT_MODIFIED);
	            }
	        } else {
	            return new ResponseEntity<>("El usuario buscado no existe", HttpStatus.NOT_FOUND);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        return new ResponseEntity<>("Usuario no modificado: " + e.getMessage(), HttpStatus.NOT_MODIFIED);
	    }
	}
	
	private String generarPasswordAleatoria(int length) {
	    
	    String caracteres = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()-_=+";
	    StringBuilder password = new StringBuilder();
	    
	    for (int i = 0; i < length; i++) {
	        int indice = (int) (Math.random() * caracteres.length());
	        password.append(caracteres.charAt(indice));
	    }
	    return ("{noop}" + password.toString());
	}
	
	private boolean isValidToken(HttpServletRequest request) {
		String authHeader = request.getHeader("Authorization");

		if (authHeader != null && authHeader.startsWith("Bearer ")) {
			String token = authHeader.substring(7); // Eliminar "Bearer "
			return jwtTokenUtil.validateToken(token);
		}

		return false; // No hay token o no tiene el formato esperado
	}
}
