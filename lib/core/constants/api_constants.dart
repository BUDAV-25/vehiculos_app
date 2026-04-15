class ApiConstants {
  static const String baseUrl = 'https://taller-itla.ia3x.com/api';

  // AUTH
  static const String registro = '/auth/registro';
  static const String activar = '/auth/activar';
  static const String login = '/auth/login';
  static const String olvidar = '/auth/olvidar';
  static const String refresh = '/auth/refresh';
  static const String cambiarClave = '/auth/cambiar-clave';

  // PERFIL
  static const String profile = '/perfil';
  static const String profilePhoto = '/perfil/foto';

  // VEHICULOS
  static const String vehiculos = '/vehiculos';
  static const String vehiculoDetalle = '/vehiculos/detalle';
  static const String vehiculoEditar = '/vehiculos/editar';
  static const String vehiculoFoto = '/vehiculos/foto';

  // MANTENIMIENTOS
  static const String mantenimientos = '/mantenimientos';

  // COMBUSTIBLE
  static const String combustibles = '/combustibles';

  // GOMAS
  static const String gomas = '/gomas';
  static const String gomasActualizar = '/gomas/actualizar';
  static const String gomasPinchazos = '/gomas/pinchazos';

  // GASTOS / INGRESOS
  static const String gastos = '/gastos';
  static const String ingresos = '/ingresos';
  static const String categoriasGastos = '/gastos/categorias';

  // NOTICIAS
  static const String noticias = '/noticias';
  static const String noticiaDetalle = '/noticias/detalle';

  // VIDEOS
  static const String videos = '/videos';

  // CATALOGO
  static const String catalogo = '/catalogo';
  static const String catalogoDetalle = '/catalogo/detalle';

  // FORO
  static const String foroCrear = '/foro/crear';
  static const String foroResponder = '/foro/responder';
  static const String foroTemas = '/foro/temas';
  static const String foroDetalle = '/foro/detalle';
  static const String foroMisTemas = '/foro/mis-temas';

  // IMAGENES
  static const String imagen = '/imagen';

  // HELPERS
  static String buildImageUrl(String path) {
    return "$baseUrl$imagen?path=$path";
  }
}