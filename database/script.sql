-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema siger
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `siger` ;

-- -----------------------------------------------------
-- Schema siger
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `siger` ;
USE `siger` ;

-- -----------------------------------------------------
-- Table `siger`.`administradores`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `siger`.`administradores` ;

CREATE TABLE IF NOT EXISTS `siger`.`administradores` (
  `email` VARCHAR(64) NOT NULL,
  `contrasena` VARCHAR(160) NOT NULL,
  `nombre` VARCHAR(48) NOT NULL,
  `apellido_paterno` VARCHAR(48) NOT NULL,
  `apellido_materno` VARCHAR(48) NOT NULL,
  PRIMARY KEY (`email`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `siger`.`carreras`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `siger`.`carreras` ;

CREATE TABLE IF NOT EXISTS `siger`.`carreras` (
  `clave` CHAR(13) NOT NULL,
  `nombre_carrera` VARCHAR(45) NOT NULL,
  `admin_email` VARCHAR(64) NOT NULL,
  PRIMARY KEY (`clave`),
  INDEX `fk_carreras_admin1_idx` (`admin_email` ASC) VISIBLE,
  CONSTRAINT `fk_carreras_admin1`
    FOREIGN KEY (`admin_email`)
    REFERENCES `siger`.`administradores` (`email`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `siger`.`residentes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `siger`.`residentes` ;

CREATE TABLE IF NOT EXISTS `siger`.`residentes` (
  `email` VARCHAR(64) NOT NULL,
  `contrasena` VARCHAR(160) NOT NULL,
  `nombre` VARCHAR(48) NOT NULL,
  `apellido_paterno` VARCHAR(48) NOT NULL,
  `apellido_materno` VARCHAR(48) NULL,
  `aprobado` TINYINT NOT NULL DEFAULT 0,
  `clave_carrera` CHAR(13) NOT NULL,
  PRIMARY KEY (`email`),
  INDEX `fk_residentes_carreras1_idx` (`clave_carrera` ASC) VISIBLE,
  CONSTRAINT `fk_residentes_carreras1`
    FOREIGN KEY (`clave_carrera`)
    REFERENCES `siger`.`carreras` (`clave`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `siger`.`docentes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `siger`.`docentes` ;

CREATE TABLE IF NOT EXISTS `siger`.`docentes` (
  `email` VARCHAR(64) NOT NULL,
  `contrasena` VARCHAR(160) NOT NULL,
  `nombre` VARCHAR(48) NOT NULL,
  `apellido_paterno` VARCHAR(48) NOT NULL,
  `apellido_materno` VARCHAR(48) NOT NULL,
  PRIMARY KEY (`email`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `siger`.`materias`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `siger`.`materias` ;

CREATE TABLE IF NOT EXISTS `siger`.`materias` (
  `clave` CHAR(8) NOT NULL,
  `nombre` VARCHAR(48) NOT NULL,
  PRIMARY KEY (`clave`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `siger`.`competente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `siger`.`competente` ;

CREATE TABLE IF NOT EXISTS `siger`.`competente` (
  `email_docente` VARCHAR(64) NOT NULL,
  `clave_materia` CHAR(8) NOT NULL,
  PRIMARY KEY (`email_docente`, `clave_materia`),
  INDEX `fk_docentes_has_materias_materias1_idx` (`clave_materia` ASC) VISIBLE,
  INDEX `fk_docentes_has_materias_docentes1_idx` (`email_docente` ASC) VISIBLE,
  CONSTRAINT `fk_docentes_has_materias_docentes1`
    FOREIGN KEY (`email_docente`)
    REFERENCES `siger`.`docentes` (`email`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_docentes_has_materias_materias1`
    FOREIGN KEY (`clave_materia`)
    REFERENCES `siger`.`materias` (`clave`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `siger`.`telefonos_residentes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `siger`.`telefonos_residentes` ;

CREATE TABLE IF NOT EXISTS `siger`.`telefonos_residentes` (
  `telefono` CHAR(10) NOT NULL,
  `fijo` TINYINT NOT NULL DEFAULT 0,
  `email_residente` VARCHAR(64) NOT NULL,
  PRIMARY KEY (`telefono`),
  INDEX `fk_telefonos_residentes_residentes1_idx` (`email_residente` ASC) VISIBLE,
  CONSTRAINT `fk_telefonos_residentes_residentes1`
    FOREIGN KEY (`email_residente`)
    REFERENCES `siger`.`residentes` (`email`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `siger`.`telefonos_docentes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `siger`.`telefonos_docentes` ;

CREATE TABLE IF NOT EXISTS `siger`.`telefonos_docentes` (
  `telefono` CHAR(10) NOT NULL,
  `fijo` TINYINT NOT NULL DEFAULT 0,
  `email_docente` VARCHAR(64) NOT NULL,
  PRIMARY KEY (`telefono`),
  INDEX `fk_telefonos_docentes_docentes1_idx` (`email_docente` ASC) VISIBLE,
  CONSTRAINT `fk_telefonos_docentes_docentes1`
    FOREIGN KEY (`email_docente`)
    REFERENCES `siger`.`docentes` (`email`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `siger`.`residencias`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `siger`.`residencias` ;

CREATE TABLE IF NOT EXISTS `siger`.`residencias` (
  `idresidencia` INT NOT NULL AUTO_INCREMENT,
  `nombre_proyecto` VARCHAR(128) NOT NULL,
  `objetivo` VARCHAR(512) NOT NULL,
  `justificacion` VARCHAR(512) NOT NULL,
  `periodo` TINYINT NOT NULL DEFAULT 0,
  `ano` CHAR(4) NOT NULL,
  `descripcion_actividades` VARCHAR(1024) NOT NULL,
  `aprobado` TINYINT NOT NULL DEFAULT 0,
  `email_residente` VARCHAR(64) NOT NULL,
  `fecha_elaboracion` INT NOT NULL,
  PRIMARY KEY (`idresidencia`),
  INDEX `fk_residencia_residentes1_idx` (`email_residente` ASC) VISIBLE,
  CONSTRAINT `fk_residencia_residentes1`
    FOREIGN KEY (`email_residente`)
    REFERENCES `siger`.`residentes` (`email`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `siger`.`empresas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `siger`.`empresas` ;

CREATE TABLE IF NOT EXISTS `siger`.`empresas` (
  `idempresa` INT NOT NULL,
  `nombre` VARCHAR(128) NOT NULL,
  `representante` VARCHAR(128) NOT NULL,
  `direccion` VARCHAR(128) NOT NULL,
  `ciudad` VARCHAR(64) NOT NULL,
  `telefono` CHAR(10) NOT NULL,
  `email` VARCHAR(64) NOT NULL,
  `departamento` VARCHAR(64) NOT NULL,
  `id_residencia` INT NOT NULL,
  PRIMARY KEY (`idempresa`),
  INDEX `fk_empresa_residencia1_idx` (`id_residencia` ASC) VISIBLE,
  CONSTRAINT `fk_empresa_residencia1`
    FOREIGN KEY (`id_residencia`)
    REFERENCES `siger`.`residencias` (`idresidencia`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `siger`.`asesores_externos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `siger`.`asesores_externos` ;

CREATE TABLE IF NOT EXISTS `siger`.`asesores_externos` (
  `idasesores_externos` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(64) NOT NULL,
  `nombre_completo` VARCHAR(128) NOT NULL,
  `puesto` VARCHAR(64) NOT NULL,
  `grado_estudios` VARCHAR(48) NOT NULL,
  `telefono` CHAR(10) NOT NULL,
  `id_residencia` INT NOT NULL,
  PRIMARY KEY (`idasesores_externos`),
  INDEX `fk_asesores_externos_residencia1_idx` (`id_residencia` ASC) VISIBLE,
  CONSTRAINT `fk_asesores_externos_residencia1`
    FOREIGN KEY (`id_residencia`)
    REFERENCES `siger`.`residencias` (`idresidencia`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `siger`.`horarios`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `siger`.`horarios` ;

CREATE TABLE IF NOT EXISTS `siger`.`horarios` (
  `idhorarios` INT NOT NULL,
  `inicio` CHAR(5) NOT NULL,
  `fin` CHAR(5) NOT NULL,
  `id_residencia` INT NOT NULL,
  PRIMARY KEY (`idhorarios`),
  INDEX `fk_horarios_residencia1_idx` (`id_residencia` ASC) VISIBLE,
  CONSTRAINT `fk_horarios_residencia1`
    FOREIGN KEY (`id_residencia`)
    REFERENCES `siger`.`residencias` (`idresidencia`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `siger`.`involucrados`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `siger`.`involucrados` ;

CREATE TABLE IF NOT EXISTS `siger`.`involucrados` (
  `email_docente` VARCHAR(64) NOT NULL,
  `id_residencia` INT NOT NULL,
  `es_asesor` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`email_docente`, `id_residencia`),
  INDEX `fk_docentes_has_residencia_residencia1_idx` (`id_residencia` ASC) VISIBLE,
  INDEX `fk_docentes_has_residencia_docentes1_idx` (`email_docente` ASC) VISIBLE,
  CONSTRAINT `fk_docentes_has_residencia_docentes1`
    FOREIGN KEY (`email_docente`)
    REFERENCES `siger`.`docentes` (`email`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_docentes_has_residencia_residencia1`
    FOREIGN KEY (`id_residencia`)
    REFERENCES `siger`.`residencias` (`idresidencia`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `siger`.`anexo_29`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `siger`.`anexo_29` ;

CREATE TABLE IF NOT EXISTS `siger`.`anexo_29` (
  `idanexo_29` INT NOT NULL AUTO_INCREMENT,
  `fecha` INT NOT NULL,
  `evaluacion_externa` VARCHAR(24) NOT NULL,
  `observaciones_externas` VARCHAR(128) NOT NULL,
  `evaluacion_interna` VARCHAR(17) NOT NULL,
  `observaciones_internas` VARCHAR(128) NOT NULL,
  `id_residencia` INT NOT NULL,
  PRIMARY KEY (`idanexo_29`),
  INDEX `fk_anexo_29_residencia1_idx` (`id_residencia` ASC) VISIBLE,
  CONSTRAINT `fk_anexo_29_residencia1`
    FOREIGN KEY (`id_residencia`)
    REFERENCES `siger`.`residencias` (`idresidencia`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `siger`.`anexo_30`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `siger`.`anexo_30` ;

CREATE TABLE IF NOT EXISTS `siger`.`anexo_30` (
  `idanexo_30` INT NOT NULL AUTO_INCREMENT,
  `fecha` INT NOT NULL,
  `evaluacion_externa` VARCHAR(28) NOT NULL,
  `observaciones_externas` VARCHAR(128) NOT NULL,
  `evaluacion_interna` VARCHAR(28) NOT NULL,
  `observaciones_internas` VARCHAR(128) NOT NULL,
  `id_residencia` INT NOT NULL,
  PRIMARY KEY (`idanexo_30`),
  INDEX `fk_anexo_30_residencia1_idx` (`id_residencia` ASC) VISIBLE,
  CONSTRAINT `fk_anexo_30_residencia1`
    FOREIGN KEY (`id_residencia`)
    REFERENCES `siger`.`residencias` (`idresidencia`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

/* --------------------------------------------------------

	STORED PROCEDURES.

-------------------------------------------------------- */
DELIMITER ;;

DROP PROCEDURE IF EXISTS SP_MostrarCarreras;;
CREATE PROCEDURE SP_MostrarCarreras() BEGIN
	select clave, nombre_carrera from carreras order by nombre_carrera;
END;;

DROP PROCEDURE IF EXISTS SP_RegistroResidente;;
CREATE PROCEDURE SP_RegistroResidente(
  v_email VARCHAR(64),
  v_contrasena VARCHAR(160),
  v_nombre VARCHAR(48),
  v_apellido_paterno VARCHAR(48),
  v_apellido_materno VARCHAR(48),
  v_clave_carrera CHAR(13),
  v_tel_cel CHAR(10),
  v_tel_fijo CHAR(10)
) BEGIN
  DECLARE exit handler for SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1
    @p2 = MESSAGE_TEXT;
    
    SELECT "0" AS output, @p2 AS message;
    
    ROLLBACK;
  END;

  START TRANSACTION;
    INSERT INTO `siger`.`residentes`
      (email, contrasena, nombre, apellido_paterno, apellido_materno, clave_carrera)
    VALUES
      (v_email, v_contrasena, v_nombre, v_apellido_paterno, v_apellido_materno, v_clave_carrera);

	
    INSERT INTO `siger`.`telefonos_residentes` 
      (telefono, email_residente, fijo)
    VALUES
      (v_tel_cel, v_email, 0),
      (v_tel_fijo, v_email, 1);

    SELECT "1" AS output, "Transaction commited successfully" AS message;
  COMMIT;
END;;

DELIMITER ;

/* --------------------------------------------------------

	INSERTS.

-------------------------------------------------------- */
-- ---------------------------------------------
-- administradores
-- ---------------------------------------------
-- Las contraseñas de estos administradores fueron encriptadas usando la clave [H5n7jMcgSA^&Rz%ZxyFE@&E#zSteW$jx].
INSERT INTO `siger`.`administradores` 
	(email, contrasena, nombre, apellido_paterno, apellido_materno)
VALUES
	('daniel.hs@piedrasnegras.tecnm.mx', '972f6b2e8738af3347b546d00bf721e6899994c2da737a3c062878bfdafd4e498a9a9f868bcf3c91726223ba745b566a59843db4d2507c499bca8db65c05f9a30fa949e656db5299f468b3f64d4d223f', 'Daniel', 'Hernández', 'Sánchez'),
	('roberto.ds@piedrasnegras.tecnm.mx', 'd9078571e8c5bd3321237d557aee5293f942a4036fc2426b8ce1a7f4131282aa1e09388354adcf7dac24e073caeaf90ea8d4565147d136511e547cad118465a2cee26c36b675ffe73975fbc601095a63', 'Roberto Carlos', 'Díaz', 'Sánchez');

-- ---------------------------------------------
-- carreras
-- ---------------------------------------------
INSERT INTO `siger`.`carreras`
	(clave, nombre_carrera, admin_email)
VALUES
	('copu-2010-205', 'Contador Público', 'daniel.hs@piedrasnegras.tecnm.mx'),
	('ielc-2010-211', 'Ingeniería Electrónica', 'daniel.hs@piedrasnegras.tecnm.mx'),
	('igem-2009-201', 'Ingeniería en Gestión Empresarial', 'daniel.hs@piedrasnegras.tecnm.mx'),
	('iind-2010-227', 'Ingeniería Industrial', 'daniel.hs@piedrasnegras.tecnm.mx'),
	('imce-2010-229', 'Ingeniería Mecatrónica', 'roberto.ds@piedrasnegras.tecnm.mx'),
	('imec-2010-228', 'Ingeniería Mecánica', 'roberto.ds@piedrasnegras.tecnm.mx'),
	('isic-2010-204', 'Ingeniería en Sistemas Computacionales', 'roberto.ds@piedrasnegras.tecnm.mx'),
	('itic-2010-225', 'Ingeniería en TIC\'s', 'roberto.ds@piedrasnegras.tecnm.mx');
