SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `san_telmo_verde`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `denuncias`
--

CREATE TABLE IF NOT EXISTS `denuncias` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `propuesta_id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `motivo` varchar(500) DEFAULT '',
  `estado` enum('pendiente','revisada','descartada') DEFAULT 'pendiente',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `fichas_mapa`
--

CREATE TABLE IF NOT EXISTS `fichas_mapa` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `titulo` varchar(255) NOT NULL,
  `descripcion` text NOT NULL,
  `tipo` varchar(50) NOT NULL,
  `etiqueta` varchar(100) NOT NULL,
  `coordenada_x` decimal(6,2) DEFAULT NULL,
  `coordenada_y` decimal(6,2) DEFAULT NULL,
  `estado_general` varchar(50) DEFAULT 'ACTIVO',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `propuestas`
--

CREATE TABLE IF NOT EXISTS `propuestas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `titulo` varchar(255) NOT NULL,
  `direccion` varchar(255) NOT NULL,
  `descripcion` text NOT NULL,
  `tipo` varchar(100) NOT NULL,
  `votos` int(11) DEFAULT 1,
  `nombre_usuario` varchar(100) DEFAULT 'Anonimo',
  `usuario_id` int(11) DEFAULT NULL,
  `estado` enum('Nueva','En revisión','Aprobada','Archivada') DEFAULT 'Nueva',
  `latitud` decimal(10,7) DEFAULT NULL,
  `longitud` decimal(10,7) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE IF NOT EXISTS `usuarios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `google_id` varchar(255) DEFAULT NULL,
  `fecha_registro` timestamp NOT NULL DEFAULT current_timestamp(),
  `puntos_trivia` int(11) NOT NULL DEFAULT 0,
  `tiempo_trivia` int(11) NOT NULL DEFAULT 0,
  `baneado_hasta` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `votos_propuesta`
--

CREATE TABLE IF NOT EXISTS `votos_propuesta` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `propuesta_id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `fecha_voto` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `zonas_mapa`
--

CREATE TABLE IF NOT EXISTS `zonas_mapa` (
  `id` varchar(50) NOT NULL,
  `tipo` enum('verde','calor') NOT NULL,
  `titulo` varchar(255) NOT NULL,
  `resumen` varchar(255) NOT NULL DEFAULT '',
  `detalle` text NOT NULL,
  `latitud` decimal(10,7) NOT NULL,
  `longitud` decimal(10,7) NOT NULL,
  `simbolo` varchar(5) NOT NULL DEFAULT '',
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `orden` int(11) NOT NULL DEFAULT 0,
  `likes` int(11) NOT NULL DEFAULT 0,
  `creado_por` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `likes_zona`
--

CREATE TABLE IF NOT EXISTS `likes_zona` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `zona_id` varchar(50) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `like_unico` (`zona_id`,`usuario_id`),
  KEY `usuario_id` (`usuario_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Volcado de datos para la tabla `zonas_mapa`
--

INSERT IGNORE INTO `zonas_mapa` (`id`, `tipo`, `titulo`, `resumen`, `detalle`, `latitud`, `longitud`, `simbolo`) VALUES
  ('verde-lezama', 'verde', 'Parque Lezama', '7.2 ha · El más grande del barrio', 'El espacio verde más grande de San Telmo, con 7.2 hectáreas. Zona histórica con anfiteatro, el Museo Histórico Nacional y una gran variedad de árboles añosos.', -34.6289, -58.3697, 'P'),
  ('verde-dorrego', 'verde', 'Plazoleta Dorrego', '0.3 ha · Centro histórico', 'Plaza chica en pleno centro histórico de San Telmo, rodeada de anticuarios. Sede de la feria de los domingos.', -34.6212, -58.3731, ''),
  ('verde-humberto', 'verde', 'Plazoleta Calle Humberto', 'Pequeña plaza de barrio', 'Espacio verde chico sobre la calle Humberto Primo, de uso vecinal cotidiano.', -34.6175, -58.3720, ''),
  ('calor-norte', 'calor', 'Isla de calor · Zona norte', '+3.2°C', 'Zona con muy poca cobertura verde y alta densidad de construcción, lo que eleva la temperatura superficial respecto al resto del barrio.', -34.6165, -58.3775, ''),
  ('calor-centro', 'calor', 'Isla de calor · Zona central', '+2.8°C', 'Concentración de superficies de asfalto y hormigón sin arbolado que retienen calor durante el día y lo liberan de noche.', -34.6245, -58.3715, ''),
  ('calor-este', 'calor', 'Isla de calor · Zona este', '+4.1°C', 'La zona con mayor diferencia de temperatura registrada del barrio, cerca de la avenida Paseo Colón, con escasa vegetación.', -34.6195, -58.3675, '');

-- --------------------------------------------------------

--
-- Claves únicas e índices adicionales
--

ALTER TABLE `denuncias`
  ADD UNIQUE KEY `denuncia_unica` (`propuesta_id`,`usuario_id`),
  ADD KEY `usuario_id` (`usuario_id`);

ALTER TABLE `propuestas`
  ADD KEY `usuario_id` (`usuario_id`);

ALTER TABLE `usuarios`
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `google_id` (`google_id`);

ALTER TABLE `votos_propuesta`
  ADD UNIQUE KEY `voto_unico` (`propuesta_id`,`usuario_id`),
  ADD KEY `usuario_id` (`usuario_id`);

-- --------------------------------------------------------

--
-- Restricciones y claves foráneas
--

ALTER TABLE `denuncias`
  ADD CONSTRAINT `denuncias_ibfk_1` FOREIGN KEY (`propuesta_id`) REFERENCES `propuestas` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `denuncias_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

ALTER TABLE `votos_propuesta`
  ADD CONSTRAINT `votos_propuesta_ibfk_1` FOREIGN KEY (`propuesta_id`) REFERENCES `propuestas` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `votos_propuesta_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;
