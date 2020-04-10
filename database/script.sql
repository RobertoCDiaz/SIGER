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
	INDEX `fk_carreras_admin1_idx` (`admin_email` ASC), -- VISIBLE,
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
	`fecha_creacion` VARCHAR(14) NOT NULL,
	`clave_carrera` CHAR(13) NOT NULL,
	PRIMARY KEY (`email`),
	INDEX `fk_residentes_carreras1_idx` (`clave_carrera` ASC), -- VISIBLE,
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
	INDEX `fk_docentes_has_materias_materias1_idx` (`clave_materia` ASC), -- VISIBLE,
	INDEX `fk_docentes_has_materias_docentes1_idx` (`email_docente` ASC), -- VISIBLE,
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
	INDEX `fk_telefonos_residentes_residentes1_idx` (`email_residente` ASC), -- VISIBLE,
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
	INDEX `fk_telefonos_docentes_docentes1_idx` (`email_docente` ASC), -- VISIBLE,
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
	`fecha_elaboracion` VARCHAR(14) NOT NULL,
	`email_residente` VARCHAR(64) NOT NULL,
	PRIMARY KEY (`idresidencia`),
	INDEX `fk_residencia_residentes1_idx` (`email_residente` ASC), -- VISIBLE,
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
  `idempresa` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(128) NOT NULL,
  `representante` VARCHAR(128) NOT NULL,
  `direccion` VARCHAR(128) NOT NULL,
  `ciudad` VARCHAR(64) NOT NULL,
  `telefono` CHAR(10) NOT NULL,
  `email` VARCHAR(64) NOT NULL,
  `departamento` VARCHAR(64) NOT NULL,
  `id_residencia` INT NOT NULL,
  PRIMARY KEY (`idempresa`),
  INDEX `fk_empresa_residencia1_idx` (`id_residencia` ASC), -- VISIBLE,
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
	INDEX `fk_asesores_externos_residencia1_idx` (`id_residencia` ASC), -- VISIBLE,
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
  `idhorarios` INT NOT NULL AUTO_INCREMENT,
  `inicio` CHAR(5) NOT NULL,
  `fin` CHAR(5) NOT NULL,
  `id_residencia` INT NOT NULL,
  PRIMARY KEY (`idhorarios`),
  INDEX `fk_horarios_residencia1_idx` (`id_residencia` ASC), -- VISIBLE,
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
	INDEX `fk_docentes_has_residencia_residencia1_idx` (`id_residencia` ASC), -- VISIBLE,
	INDEX `fk_docentes_has_residencia_docentes1_idx` (`email_docente` ASC), -- VISIBLE,
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
	`fecha` VARCHAR(14) NOT NULL,
	`evaluacion_externa` VARCHAR(24) NOT NULL,
	`observaciones_externas` VARCHAR(128) NOT NULL,
	`evaluacion_interna` VARCHAR(17) NOT NULL,
	`observaciones_internas` VARCHAR(128) NOT NULL,
	`id_residencia` INT NOT NULL,
	PRIMARY KEY (`idanexo_29`),
	INDEX `fk_anexo_29_residencia1_idx` (`id_residencia` ASC), -- VISIBLE,
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
	`fecha` VARCHAR(14) NOT NULL,
	`evaluacion_externa` VARCHAR(28) NOT NULL,
	`observaciones_externas` VARCHAR(128) NOT NULL,
	`evaluacion_interna` VARCHAR(28) NOT NULL,
	`observaciones_internas` VARCHAR(128) NOT NULL,
	`id_residencia` INT NOT NULL,
	PRIMARY KEY (`idanexo_30`),
	INDEX `fk_anexo_30_residencia1_idx` (`id_residencia` ASC), -- VISIBLE,
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

	FUNCTIONS.

-------------------------------------------------------- */
DELIMITER ;;

/*
	Comprueba si el adminstrador cuyo correo electrónico es
	[v_email_admin] tiene la capacidad de validar al residente
	con correo [v_email_residente].

	Regresa 1 si dicho administrador puede validar al residente.
	Regresa 0 si no.
*/	
DROP FUNCTION IF EXISTS puedeValidarResidente;;
CREATE FUNCTION puedeValidarResidente(
	v_email_residente VARCHAR(64),
	v_email_admin VARCHAR(64)
) RETURNS TINYINT DETERMINISTIC BEGIN 
	set @realAdminEmail = (
		select 
			c.admin_email
		from 
			residentes as r join carreras as c
				on c.clave = r.clave_carrera
		where r.email = v_email_residente
	);

	IF v_email_admin = @realAdminEmail THEN BEGIN
		RETURN 1;
	END; END IF;

	RETURN 0;
END;;

DELIMITER ;

/* --------------------------------------------------------

	STORED PROCEDURES.

-------------------------------------------------------- */
DELIMITER ;;

/*
	Muestra una lista simplificada de las carreras disponibles.
	Esta lista solo contendrá la clave de la carrera, así como 
	el nombre de esta.
*/
DROP PROCEDURE IF EXISTS SP_MostrarCarreras;;
CREATE PROCEDURE SP_MostrarCarreras() BEGIN
	select clave, nombre_carrera from carreras order by nombre_carrera;
END;;


/*
	A partir de los datos proporcionados como parámetros,
	crea las filas en las tablas necesarias para el 
	registro de un nuevo residente en el sistema.
	Este residente nuevo no estará confirmado.

	[output] será 1 si todo salió bien.
	Si ocurre alguna excepción en la transacción,
	[output] será -1, mientras [message] indica el
	origen de la excepción.
*/
DROP PROCEDURE IF EXISTS SP_RegistroResidente;;
CREATE PROCEDURE SP_RegistroResidente(
	v_email VARCHAR(64),
	v_contrasena VARCHAR(160),
	v_nombre VARCHAR(48),
	v_apellido_paterno VARCHAR(48),
	v_apellido_materno VARCHAR(48),
	v_fecha_creacion VARCHAR(14),
	v_clave_carrera CHAR(13),
	v_tel_cel CHAR(10),
	v_tel_fijo CHAR(10)
) BEGIN
	DECLARE exit handler for SQLEXCEPTION
	BEGIN
		GET DIAGNOSTICS CONDITION 1
		@p2 = MESSAGE_TEXT;
		
		SELECT "-1" AS output, @p2 AS message;
		
		ROLLBACK;
	END;

	START TRANSACTION;
		INSERT INTO `siger`.`residentes`
			(email, contrasena, nombre, apellido_paterno, apellido_materno, fecha_creacion, clave_carrera)
		VALUES
			(v_email, v_contrasena, v_nombre, v_apellido_paterno, v_apellido_materno, v_fecha_creacion, v_clave_carrera);

	
		INSERT INTO `siger`.`telefonos_residentes` 
			(telefono, email_residente, fijo)
		VALUES
			(v_tel_cel, v_email, 0),
			(v_tel_fijo, v_email, 1);

		SELECT "1" AS output, "Transaction committed successfully" AS message;
	COMMIT;
END;;


/*
	Muestra una lista de los residentes que actualmente están sin validar y que
	pertenecen a alguna de las carreras administradas por el dueño del correo
	electrónico [v_email_admin].
*/
DROP PROCEDURE IF EXISTS SP_ResidentesNoValidados;;
CREATE PROCEDURE SP_ResidentesNoValidados(
	v_email_admin VARCHAR(64)
) BEGIN
	select 
		r.email, substring(r.email, 2, 8) as `noControl`, r.nombre, r.apellido_paterno, r.apellido_materno,
		(select t.telefono from telefonos_residentes as t where r.email = t.email_residente and fijo = 0) as `celular`,
		(select t.telefono from telefonos_residentes as t where r.email = t.email_residente and fijo = 1) as `tel`,
		r.fecha_creacion, c.nombre_carrera as `carrera`
	from 
		residentes as r join carreras as c 
			on c.clave = r.clave_carrera
	where 
		aprobado = 0 and
	c.admin_email = v_email_admin
	order by 
		r.fecha_creacion, `noControl`;
END;;


/*
	Valida al residente con correo [v_email_residente] 
	solo si el administrador con el correo electrónico 
	[v_email_admin] tiene la capacidad de hacerlo.

	El [output] será 1 si se logró validar al residente.
	Será 0 si hay algún problema, además de informarse con
	[message].
	En caso de ocurrir alguna excepción en la transacción,
	[output] será -1. La razón será proporcionada a [message].
*/
DROP PROCEDURE IF EXISTS SP_ValidarResidente;;
CREATE PROCEDURE SP_ValidarResidente(
	v_email_residente VARCHAR(64),
	v_email_admin VARCHAR(64)
) BEGIN
	DECLARE exit handler for SQLEXCEPTION
	BEGIN
		GET DIAGNOSTICS CONDITION 1
		@p2 = MESSAGE_TEXT;
		
		SELECT "-1" AS output, @p2 AS message;
		
		ROLLBACK;
	END;

	START TRANSACTION;

	IF (puedeValidarResidente(v_email_residente, v_email_admin)) != 1 THEN BEGIN
		SELECT "0" AS output, "Este administrador no puede validar a este residente" AS message;
		END; 
	ELSEIF (SELECT COUNT(*) FROM `siger`.`residentes` AS r WHERE r.email = v_email_residente) = 0 THEN BEGIN
			SELECT "0" AS output, "No existe un residente con este email" AS message;
		END; 
		ELSEIF (SELECT COUNT(*) FROM `siger`.`residentes` AS r WHERE r.email = v_email_residente AND r.aprobado = 0) = 0 THEN BEGIN
			SELECT "0" AS output, "Este residente ya está validado" AS message;
		END; ELSE BEGIN
			UPDATE `siger`.`residentes` AS r SET r.aprobado = 1 WHERE r.email = v_email_residente;

			SELECT "1" AS output, "Residente validado con éxito" AS message; 
		END; END IF;
	
	COMMIT;
END;;


DROP PROCEDURE IF EXISTS SP_RegistroResidencia;;
CREATE PROCEDURE SP_RegistroResidencia(
  v_nombre_proyecto VARCHAR(128),
  v_objetivo VARCHAR(512),
  v_justificacion VARCHAR(512),
  v_periodo TINYINT,
  v_ano CHAR(4),
  v_descripcion_actividades VARCHAR(1024),
  v_aprobado TINYINT,
  v_email_residente VARCHAR(64),
  v_fecha_elaboracion VARCHAR(14),
  v_nombre_empresa varchar(128),
  v_representante varchar (128),
  v_direccion varchar(128),
  v_ciudad varchar (64),
  v_telefono char(10),
  v_email varchar(64),
  v_departamento varchar(64),
  v_email_ae varchar(64),
  v_nombre_ae varchar(128),
  v_puesto varchar(64),
  v_grado_estudios varchar(48),
  v_tel_ae char(10)
)
BEGIN
  DECLARE exit handler for SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1
    @p2 = MESSAGE_TEXT;
    
    SELECT "0" AS output, @p2 AS message;
    
    ROLLBACK;
  END;

  START TRANSACTION;
    INSERT INTO `siger`.`residencias`
      (nombre_proyecto, objetivo, justificacion, periodo, ano, descripcion_actividades,aprobado,email_residente,fecha_elaboracion)
    VALUES
      (v_nombre_proyecto, v_objetivo, v_justificacion, v_periodo, v_ano, v_descripcion_actividades, v_aprobado, v_email_residente, v_fecha_elaboracion);

	set @idr = last_insert_id();
      
	INSERT INTO `siger`.`empresas` 
      (nombre, representante, direccion, ciudad, telefono, email, departamento, id_residencia)
    VALUES
      (v_nombre_empresa, v_representante, v_direccion,v_ciudad, v_telefono, v_email, v_departamento, @idr);
      
	INSERT INTO `siger`.`asesores_externos` 
      (email, nombre_completo, puesto, grado_estudios, telefono, id_residencia)
    VALUES
      (v_email_ae, v_nombre_ae, v_puesto,v_grado_estudios, v_tel_ae, @idr);

    SELECT "1" AS output, "Transaction commited successfully" AS message;
  COMMIT;
END;;

DROP procedure IF EXISTS `SP_RegistraHorarios`;
CREATE PROCEDURE `SP_RegistraHorarios`(
  v_inicio CHAR(5),
  v_fin CHAR(5),
  v_idresidencia INT
)
BEGIN
  DECLARE exit handler for SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1
    @p2 = MESSAGE_TEXT;
    
    SELECT "0" AS output, @p2 AS message;
    
    ROLLBACK;
  END;

  START TRANSACTION;
    INSERT INTO `siger`.`horarios`
      (inicio, fin, idresidencia)
    VALUES
      (v_inicio, v_fin, v_idresidencia);

    SELECT "1" AS output, "Transaction commited successfully" AS message;
  COMMIT;
END$$

DELIMITER ;

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
	('itic-2010-225', 'Ingeniería en TICs', 'roberto.ds@piedrasnegras.tecnm.mx');