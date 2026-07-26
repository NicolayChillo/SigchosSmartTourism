// Catálogo real del cantón Sigchos, transcrito de
// data_source/Información Turística de Sigchos.pdf. Se usa una sola vez desde
// el botón "Cargar catálogo inicial" del panel de administración para poblar
// Firestore reusando el mismo pipeline (LugaresViewModel.createLugar/...) que
// usa el resto de la app.
import '../../domain/entities/lugar.dart';
import '../../domain/entities/hosteria.dart';
import '../../domain/entities/emprendimiento.dart';
import '../utils/geohash_helper.dart';

List<String> _photos(String category, String slug, int count) {
  return List.generate(
    count,
    (i) => 'assets/images/$category/$slug/${i + 1}.jpg',
  );
}

final DateTime _seedDate = DateTime(2026, 1, 1);

/// 14 atractivos naturales/arqueológicos del cantón, con coordenadas reales
/// tomadas del PDF. `tipo` usa 6 categorías: cascada, laguna, mirador,
/// sendero, historico, cultural.
final List<Lugar> seedLugares = [
  Lugar(
    id: '',
    nombre: 'Laguna de Quilotoa',
    tipo: 'laguna',
    descripcion:
        'Espléndido lago de cráter de color verdeturquesa formado dentro de una caldera volcánica de tres kilómetros de diámetro, producto del colapso del volcán hace aproximadamente 800 años. Sus aguas, con una profundidad aproximada de 250 metros, cambian de tonalidad según la luz solar, las nubes y los minerales disueltos. Cuenta con fumarolas en el fondo del lago y manantiales termales en su flanco este. Ideal para senderismo (circunvalación de la caldera), kayak, campamento nocturno y cabalgatas.\nParroquia: Chugchilán.',
    fotos: _photos('atractivos', 'laguna-de-quilotoa', 3),
    latitude: -0.867189,
    longitude: -78.908401,
    geohash: GeohashHelper.encodeGeohash(-0.867189, -78.908401),
    promedioCalificacion: 0,
    totalCalificaciones: 0,
    creadoPor: 'seed',
    fechaCreacion: _seedDate,
  ),
  Lugar(
    id: '',
    nombre: 'Bosque Protector Sarapullo',
    tipo: 'sendero',
    descripcion:
        'Refugio de bosque húmedo montano de unas 21.585 hectáreas, establecido para conservar las cuencas de los ríos Toachi y Pilatón, vitales para el abastecimiento hídrico y la biodiversidad regional. Históricamente funcionó como zona minera durante la colonia. Declarado Bosque Protector el 26 de junio de 1986.\nParroquia: Palo Quemado.',
    fotos: _photos('atractivos', 'bosque-protector-sarapullo', 3),
    latitude: -0.436113,
    longitude: -78.96656,
    geohash: GeohashHelper.encodeGeohash(-0.436113, -78.96656),
    promedioCalificacion: 0,
    totalCalificaciones: 0,
    creadoPor: 'seed',
    fechaCreacion: _seedDate,
  ),
  Lugar(
    id: '',
    nombre: 'Cañón del Toachi',
    tipo: 'mirador',
    descripcion:
        'Impresionante formación natural creada por flujos piroclásticos del volcán Quilotoa hace aproximadamente 1800 años, compuesta por roca pómez, lapillis y bombas volcánicas. Sus paredes alcanzan alrededor de 40 metros de altura. El río Toachi atraviesa el fondo del cañón, generando vistas espectaculares desde miradores naturales junto a la vía de acceso a Sigchos. Ideal para senderismo, fotografía, miradores panorámicos y rafting.',
    fotos: _photos('atractivos', 'canon-del-toachi', 3),
    latitude: -0.875,
    longitude: -78.8865,
    geohash: GeohashHelper.encodeGeohash(-0.875, -78.8865),
    promedioCalificacion: 0,
    totalCalificaciones: 0,
    creadoPor: 'seed',
    fechaCreacion: _seedDate,
  ),
  Lugar(
    id: '',
    nombre: 'Churo de Amanta',
    tipo: 'historico',
    descripcion:
        'Fortaleza inca prehispánica, conocida como "el Machu Picchu ecuatoriano", ubicada en la cima de un cerro. Cuenta con ruinas de estructuras en forma de cruz, túneles, canales y caminos empedrados que evocan su uso estratégico militar y ceremonial. Desde allí se dominaba visualmente los movimientos enemigos y se realizaban rituales al Padre Sol durante el Inti Raymi.\nParroquia: Chugchilán.',
    fotos: _photos('atractivos', 'churo-de-amanta', 4),
    latitude: -0.757519,
    longitude: -78.929956,
    geohash: GeohashHelper.encodeGeohash(-0.757519, -78.929956),
    promedioCalificacion: 0,
    totalCalificaciones: 0,
    creadoPor: 'seed',
    fechaCreacion: _seedDate,
  ),
  Lugar(
    id: '',
    nombre: 'Columnas de Tangán',
    tipo: 'historico',
    descripcion:
        'Formaciones rocosas volcánicas (farallones) en forma de columna, algunas con tallados prehispánicos, que ocupan unas cuatro hectáreas y alcanzan entre 100 y 120 m de altura. Aunque son naturales (roca basáltica), tienen marcas que podrían remitir a intervención incaica o Sigchila, combinando valor arqueológico y paisajístico. Se practica senderismo, escalada en roca y camping.\nParroquia: Sigchos.',
    fotos: _photos('atractivos', 'columnas-de-tangan', 4),
    latitude: -0.674541,
    longitude: -78.88005,
    geohash: GeohashHelper.encodeGeohash(-0.674541, -78.88005),
    promedioCalificacion: 0,
    totalCalificaciones: 0,
    creadoPor: 'seed',
    fechaCreacion: _seedDate,
  ),
  Lugar(
    id: '',
    nombre: 'Licamancha',
    tipo: 'cascada',
    descripcion:
        'Una de las joyas naturales más impresionantes de Sigchos: una cascada con caída libre de más de 100 metros que se desliza entre formaciones rocosas y vegetación andina exuberante. Ideal para senderismo, fotografía y deportes de aventura como el canyoning y el péndulo. En los meses fríos, sus aguas pueden formar estructuras de hielo.\nParroquia: Chugchilán.',
    fotos: _photos('atractivos', 'licamancha', 3),
    latitude: -0.929253,
    longitude: -78.906159,
    geohash: GeohashHelper.encodeGeohash(-0.929253, -78.906159),
    promedioCalificacion: 0,
    totalCalificaciones: 0,
    creadoPor: 'seed',
    fechaCreacion: _seedDate,
  ),
  Lugar(
    id: '',
    nombre: 'Los Ilinizas',
    tipo: 'sendero',
    descripcion:
        'Conjunto volcánico gemelo dentro de la Reserva Ecológica Los Ilinizas, que protege unas 149.900 ha de páramo y bosque andino. Consta del Iliniza Norte (~5126 m), más accesible, y el Iliniza Sur (~5263 m), con glaciares. Desde sus cumbres se observan volcanes como Cotopaxi, Corazón, Rumiñahui y Pasochoa. La reserva también cuenta con aguas termales (Yanacyacu y Cunucyacu).\nParroquia: Sigchos.',
    fotos: _photos('atractivos', 'los-ilinizas', 3),
    latitude: -0.66002,
    longitude: -78.715174,
    geohash: GeohashHelper.encodeGeohash(-0.66002, -78.715174),
    promedioCalificacion: 0,
    totalCalificaciones: 0,
    creadoPor: 'seed',
    fechaCreacion: _seedDate,
  ),
  Lugar(
    id: '',
    nombre: 'Aguas Termales de la Comunidad de Yanayacu',
    tipo: 'sendero',
    descripcion:
        'Aguas subterráneas que provienen del volcán Quilotoa y que, al atravesar la cordillera occidental de Chugchilán, llegan hasta esta zona de bosque montano bajo o "subtrópico". Las aguas termales tienen una temperatura de 30 a 40 grados centígrados; el lugar también posee un río y una cascada, ideal para senderismo y fotografía del paisaje montañoso.\nParroquia: Chugchilán.',
    fotos: _photos('atractivos', 'aguas-termales-de-la-comunidad-de-yanayacu', 1),
    latitude: -0.890952,
    longitude: -79.018186,
    geohash: GeohashHelper.encodeGeohash(-0.890952, -79.018186),
    promedioCalificacion: 0,
    totalCalificaciones: 0,
    creadoPor: 'seed',
    fechaCreacion: _seedDate,
  ),
  Lugar(
    id: '',
    nombre: 'Cañón del Águila',
    tipo: 'mirador',
    descripcion:
        'Larga zanja profunda formada por el movimiento de la corteza terrestre, producto de actividad geológica y volcánica de miles de años. En la actualidad está cubierto por sedimentos arenosos producto de la erosión, con vegetación de gran atractivo y belleza. Poco explorado, pero con gran potencial turístico.\nParroquia: Chugchilán.',
    fotos: _photos('atractivos', 'canon-del-aguila', 1),
    latitude: -0.8223,
    longitude: -78.91999,
    geohash: GeohashHelper.encodeGeohash(-0.8223, -78.91999),
    promedioCalificacion: 0,
    totalCalificaciones: 0,
    creadoPor: 'seed',
    fechaCreacion: _seedDate,
  ),
  Lugar(
    id: '',
    nombre: 'Mirador Chínalo Bajo',
    tipo: 'mirador',
    descripcion:
        'Vistas panorámicas espectaculares hacia el cañón, con el río Toachi recorriendo su interior. Es un punto de partida o parada de la famosa Ruta del Quilotoa (Quilotoa Loop), que atraviesa paisajes impresionantes y comunidades locales hasta llegar a la Laguna Quilotoa.\nParroquia: Chugchilán.',
    fotos: _photos('atractivos', 'mirador-chinalo-bajo', 1),
    latitude: -0.782119,
    longitude: -78.905941,
    geohash: GeohashHelper.encodeGeohash(-0.782119, -78.905941),
    promedioCalificacion: 0,
    totalCalificaciones: 0,
    creadoPor: 'seed',
    fechaCreacion: _seedDate,
  ),
  Lugar(
    id: '',
    nombre: 'Laguna de Tilinte',
    tipo: 'laguna',
    descripcion:
        'Ubicada en la comunidad de El Salado, a unos 25 minutos del centro de la parroquia Isinliví, a 3.200 msnm. Se alimenta de vertientes naturales y destaca por sus paisajes de páramo, flora nativa y avistamiento de aves (patos silvestres) y ganadería local.\nParroquia: Isinliví.',
    fotos: _photos('atractivos', 'laguna-de-tilinte', 1),
    latitude: -0.798556,
    longitude: -78.864133,
    geohash: GeohashHelper.encodeGeohash(-0.798556, -78.864133),
    promedioCalificacion: 0,
    totalCalificaciones: 0,
    creadoPor: 'seed',
    fechaCreacion: _seedDate,
  ),
  Lugar(
    id: '',
    nombre: 'La hoya del río Toachi',
    tipo: 'sendero',
    descripcion:
        'Región geográfica formada por el río Toachi y rodeada por los ramales de la cordillera Occidental de los Andes, destacada por su belleza paisajística y zona de turismo popular. Abarca una gran área de captación que incluye flancos de volcanes como el Rumiñahui, Iliniza, Corazón y Atacazo.\nParroquia: Las Pampas.',
    fotos: _photos('atractivos', 'la-hoya-del-rio-toachi', 1),
    latitude: -0.666315,
    longitude: -78.849995,
    geohash: GeohashHelper.encodeGeohash(-0.666315, -78.849995),
    promedioCalificacion: 0,
    totalCalificaciones: 0,
    creadoPor: 'seed',
    fechaCreacion: _seedDate,
  ),
  Lugar(
    id: '',
    nombre: 'Las tres chorreras del río San Pablo',
    tipo: 'cascada',
    descripcion:
        'Ubicadas en el recinto Santa Rosa, en la finca del señor Luis Maldonado. Estas chorreras forman una escalera en el río; en cada caída se forma un pailón, rodeado de vegetación que inspira un toque de tranquilidad.\nParroquia: Palo Quemado.',
    fotos: _photos('atractivos', 'las-tres-chorreras-del-rio-san-pablo', 1),
    latitude: -0.348492,
    longitude: -78.93125,
    geohash: GeohashHelper.encodeGeohash(-0.348492, -78.93125),
    promedioCalificacion: 0,
    totalCalificaciones: 0,
    creadoPor: 'seed',
    fechaCreacion: _seedDate,
  ),
  Lugar(
    id: '',
    nombre: 'Malqui y Machay',
    tipo: 'historico',
    descripcion:
        'Complejo arqueológico ("lugar del cuerpo momificado") situado en el recinto Malqui, dentro de la parroquia rural Guasaganda, que perteneció a la jurisdicción de Chugchilán. Según cronistas, los leales a Atahualpa trasladaron su cuerpo momificado desde Cajamarca hasta este punto remoto para evitar su profanación por los españoles. Cuenta con restos de muros rústicos, plazoletas, terrazas y un acueducto de características incaicas, con vestigios aún más antiguos en sus niveles inferiores. Coordenadas aproximadas (no especificadas en la fuente original).\nCategoría: Arqueológico.',
    fotos: _photos('atractivos', 'malqui-y-machay', 3),
    latitude: -0.93,
    longitude: -79.10,
    geohash: GeohashHelper.encodeGeohash(-0.93, -79.10),
    promedioCalificacion: 0,
    totalCalificaciones: 0,
    creadoPor: 'seed',
    fechaCreacion: _seedDate,
  ),
];

// Sigchos (parroquia matriz) no tiene coordenadas de negocios individuales en
// la fuente original; se aproximan alrededor del centro cantonal
// (-0.7012, -78.8872), como se acordó con el usuario.
final List<Hosteria> seedHosterias = [
  Hosteria(
    id: '',
    nombre: 'Hostal El Castillo',
    descripcion:
        'Se encuentra en la intersección de Calle Rodrigo Iturralde y General Rumiñahui (C756), a escasos dos cuadras y media desde la terminal terrestre del cantón, justo detrás de la iglesia matriz de Sigchos. Horario: todos los días de 08:00 a 20:00.',
    fotos: _photos('hosterias', 'hostal-el-castillo', 4),
    latitude: -0.7005,
    longitude: -78.8878,
    geohash: GeohashHelper.encodeGeohash(-0.7005, -78.8878),
    promedioCalificacion: 0,
    totalCalificaciones: 0,
    contacto: 'Sigchos, Cotopaxi · Consultar en sitio',
    precioRango: 'Consultar precios',
  ),
  Hosteria(
    id: '',
    nombre: 'Hostal Ilinizas',
    descripcion:
        'Hospedaje de primer nivel que ofrece habitaciones simples, dobles y matrimoniales. Horario: todos los días de 08:00 a 20:00.',
    fotos: _photos('hosterias', 'hostal-ilinizas', 3),
    latitude: -0.7018,
    longitude: -78.8865,
    geohash: GeohashHelper.encodeGeohash(-0.7018, -78.8865),
    promedioCalificacion: 0,
    totalCalificaciones: 0,
    contacto: 'Sigchos, Cotopaxi · Consultar en sitio',
    precioRango: 'Consultar precios',
  ),
  Hosteria(
    id: '',
    nombre: 'Hostería El Trapiche',
    descripcion:
        'Ubicada en Ilinizas Parque Infantil, Sigchos, a aproximadamente 1,1 km del centro del cantón. Horario: todos los días de 08:00 a 20:00.',
    fotos: _photos('hosterias', 'hosteria-el-trapiche', 4),
    latitude: -0.6942,
    longitude: -78.8802,
    geohash: GeohashHelper.encodeGeohash(-0.6942, -78.8802),
    promedioCalificacion: 0,
    totalCalificaciones: 0,
    contacto: 'Sigchos, Cotopaxi · Consultar en sitio',
    precioRango: 'Consultar precios',
  ),
  Hosteria(
    id: '',
    nombre: 'Hostería San José',
    descripcion:
        'Hostería que ofrece hospedaje a todo el público de Sigchos. Horario: todos los días de 08:00 a 20:00.',
    fotos: _photos('hosterias', 'hosteria-san-jose', 4),
    latitude: -0.7030,
    longitude: -78.8890,
    geohash: GeohashHelper.encodeGeohash(-0.7030, -78.8890),
    promedioCalificacion: 0,
    totalCalificaciones: 0,
    contacto: 'Sigchos, Cotopaxi · Consultar en sitio',
    precioRango: 'Consultar precios',
  ),
  Hosteria(
    id: '',
    nombre: 'Hostería San Miguel',
    descripcion:
        'Hostería reconocida que ofrece hospedaje para propios y extranjeros. Horario: todos los días de 08:00 a 20:00.',
    fotos: _photos('hosterias', 'hosteria-san-miguel', 4),
    latitude: -0.7040,
    longitude: -78.8860,
    geohash: GeohashHelper.encodeGeohash(-0.7040, -78.8860),
    promedioCalificacion: 0,
    totalCalificaciones: 0,
    contacto: 'Sigchos, Cotopaxi · Consultar en sitio',
    precioRango: 'Consultar precios',
  ),
];

final List<Emprendimiento> seedEmprendimientos = [
  Emprendimiento(
    id: '',
    nombre: 'El Ultimo Inca',
    categoria: 'gastronomia',
    descripcion:
        'Fábrica de vinos artesanales de mortiño, con tradición de la cultura sigchense.\nProducto: Vino de Mortiño (vino artesanal de mortiño), \$7.50.\nHorario: todos los días de 08:00 a 20:00.',
    fotos: _photos('emprendimientos', 'el-ultimo-inca', 4),
    latitude: -0.7020,
    longitude: -78.8880,
    geohash: GeohashHelper.encodeGeohash(-0.7020, -78.8880),
    promedioCalificacion: 0,
    totalCalificaciones: 0,
  ),
  Emprendimiento(
    id: '',
    nombre: 'Grandes Food',
    categoria: 'gastronomia',
    descripcion:
        'Empresa que integra toda la cadena productiva: desde productores agrícolas locales hasta el procesamiento y comercialización de alimentos. Líneas de productos: chochos, lácteos, embutidos (carnes) y otros productos vegetales.\nProducto: snacks de chocho ricos en proteína y sin gluten; carnes y embutidos (pepperoni, longaniza de Praga, chorizo español y artesanal); lácteos procesados desde la granja hasta el consumidor.\nHorario: todos los días de 08:00 a 20:00.',
    fotos: _photos('emprendimientos', 'grandes-food', 4),
    latitude: -0.7000,
    longitude: -78.8865,
    geohash: GeohashHelper.encodeGeohash(-0.7000, -78.8865),
    promedioCalificacion: 0,
    totalCalificaciones: 0,
  ),
  Emprendimiento(
    id: '',
    nombre: 'SIGCHOSLAC',
    categoria: 'gastronomia',
    descripcion:
        'Fundado en 2018 por una asociación de pequeños ganaderos locales, con el objetivo de darle valor agregado a la leche producida en la zona.\nProducto: lácteos.\nHorario: todos los días de 08:00 a 20:00.',
    fotos: _photos('emprendimientos', 'sigchoslac', 3),
    latitude: -0.7025,
    longitude: -78.8855,
    geohash: GeohashHelper.encodeGeohash(-0.7025, -78.8855),
    promedioCalificacion: 0,
    totalCalificaciones: 0,
  ),
  Emprendimiento(
    id: '',
    nombre: 'Vinos Perla Andina',
    categoria: 'gastronomia',
    descripcion:
        'Emprendimiento ecuatoriano dedicado a la elaboración de vinos artesanales andinos, fusionando técnicas tradicionales con identidad cultural local.\nProducto: Vino Tinto Andino (frutas andinas seleccionadas); Vino de Frutas Andinas (mora y mortiño); degustación de vinos guiada.\nHorario: todos los días de 08:00 a 20:00.',
    fotos: _photos('emprendimientos', 'vinos-perla-andina', 1),
    latitude: -0.6995,
    longitude: -78.8880,
    geohash: GeohashHelper.encodeGeohash(-0.6995, -78.8880),
    promedioCalificacion: 0,
    totalCalificaciones: 0,
  ),
  Emprendimiento(
    id: '',
    nombre: 'Gastronomía Tradicional de Sigchos',
    categoria: 'gastronomia',
    descripcion:
        'Platos típicos de Sigchos preparados con ingredientes locales.\nProducto: cuy asado (con papas, lechuga y salsa de maní); locro de cuy (sopa típica con mote y cuy, acompañada de chicha); runaucho (cuy asado al carbón con ají macho y colada de arveja); locro de zambo; locro de zapallo.\nHorario: todos los días de 08:00 a 20:00.',
    fotos: _photos('emprendimientos', 'gastronomia-tradicional-de-sigchos', 1),
    latitude: -0.7010,
    longitude: -78.8850,
    geohash: GeohashHelper.encodeGeohash(-0.7010, -78.8850),
    promedioCalificacion: 0,
    totalCalificaciones: 0,
  ),
];
