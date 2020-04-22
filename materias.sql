/*
Este archivo temporal contiene todas las materias de cada una de las 
carreras ofrecidas en el ITPN, separadas por especialidades.

Por cada carrera/especialidad, hay dos secciones: La primera son las
materias cuya clave no se repite. Estas ya están bien así como están.
Al terminar esta primera sección, comienzan las materias con clave
duplicada (El inicio de esta sección está marcado con un comentario).
En esta sección hay que ver cuál de las repeticiones es la materia correcta y dejarla intacta.
Las repeticiones que tienen una relación clave-materia erronea, hay que corregisrlas a mano.

Una vez terminado con los cambios que a cada quién le corresponden, subir sus
modificaciones a la rama [inserts-materias] para seguir con futuras depuraciones.

Solamente las carreras/especialidades enumeradas necesitan modificaciones, y son:

Impares:
    1. ISC. Desarrollo Web y Aplicaciones Móviles.
    3. Ingeniería en Gestión Empresarial.
    5. ITICs. Tecnologías Emergentes.

Pares:
    2. ISC. Teconologías Emergentes.
    4. ITICs. Desarrollo Web y Aplicaciones Móviles.
*/

/* --------------------------------------------------------

    1. ISC. Desarrollo Web y Aplicaciones Móviles.

-------------------------------------------------------- */
INSERT INTO materias VALUES ('acf-0901', 'Cálculo Diferencial');
INSERT INTO materias VALUES ('acf-0902', 'Cálculo Integral');
INSERT INTO materias VALUES ('acf-0904', 'Cálculo Vectorial');
INSERT INTO materias VALUES ('acf-0905', 'Ecuaciones Diferenciales');
INSERT INTO materias VALUES ('scd-1008', 'Fundamentos de Programacion');
INSERT INTO materias VALUES ('scd-1020', 'Programación Orientada a Objetos');
INSERT INTO materias VALUES ('aed-1026', 'Estructura de Datos');
INSERT INTO materias VALUES ('scc-1017', 'Métodos Numéricos');
INSERT INTO materias VALUES ('aca-0907', 'Taller de Ética');
INSERT INTO materias VALUES ('aec-1008', 'Contabilidad Financiera');
INSERT INTO materias VALUES ('scc-1005', 'Cultura Empresarial');
INSERT INTO materias VALUES ('aef-1041', 'Matemáticas Discretas');
INSERT INTO materias VALUES ('aec-1058', 'Química');
INSERT INTO materias VALUES ('scc-1013', 'Investigación de Operaciones');
INSERT INTO materias VALUES ('aef-1031', 'Fundamentos de Bases de Datos');
INSERT INTO materias VALUES ('acf-0903', 'Álgebra Lineal');
INSERT INTO materias VALUES ('sca-1026', 'Taller de Sistemas Operativos');
INSERT INTO materias VALUES ('aef-1052', 'Probabilidad y Estadística');
INSERT INTO materias VALUES ('scf-1006', 'Física General');
INSERT INTO materias VALUES ('scd-1018', 'Principios Eléctricos y Aplicaciones Digitales');
INSERT INTO materias VALUES ('acd-0908', 'Desarrollo Sustentable');
INSERT INTO materias VALUES ('scd-1015', 'Lenguajes y Autómatas I');
INSERT INTO materias VALUES ('scd-1016', 'Lenguajes y Autómatas II');
INSERT INTO materias VALUES ('scc-1019', 'Programación Lógica y Funcional');
INSERT INTO materias VALUES ('scc-1012', 'Inteligencia Artificial');
INSERT INTO materias VALUES ('aec-1034', 'Fundamentos de Telecomunicaciones');
INSERT INTO materias VALUES ('scd-1021', 'Redes de Computadora');
INSERT INTO materias VALUES ('scd-1004', 'Comunicación y Enrutamiento de Redes de Datos');
INSERT INTO materias VALUES ('sca-1002', 'Administración de redes');
INSERT INTO materias VALUES ('dwb-1404', 'Programación Multiplataforma para Aplicaciones Móviles (Especialidad)');
INSERT INTO materias VALUES ('sca-1025', 'Taller de Bases de Datos');
INSERT INTO materias VALUES ('scb-1001', 'Administración de Bases de Datos');
INSERT INTO materias VALUES ('aca-0909', 'Taller de Investigación I');
INSERT INTO materias VALUES ('aca-0910', 'Taller de Investigación II');
INSERT INTO materias VALUES ('dwd-1405', 'Diseño para Aplicaciones Móviles (Especialidad)');
INSERT INTO materias VALUES ('scd-1022', 'Simulación');
INSERT INTO materias VALUES ('aeb-1055', 'Programación Web');
INSERT INTO materias VALUES ('dwb-1401', 'Programación Web II (Especialidad)');
INSERT INTO materias VALUES ('scc-1010', 'Graficación');
INSERT INTO materias VALUES ('scc-1007', 'Fundamentos de Ingeniería de Software');
INSERT INTO materias VALUES ('scd-1011', 'Ingeniería de Software');
INSERT INTO materias VALUES ('scg-1009', 'Gestión de Proyectos de Software');
INSERT INTO materias VALUES ('dwb-1402', 'Programación de Aplicaciones Nativas para Móviles (Especialidad)');
INSERT INTO materias VALUES ('scd-1003', 'Arquitectura de Computadoras');
INSERT INTO materias VALUES ('scc-1014', 'Lenguajes de Interfaz');
INSERT INTO materias VALUES ('scc-1023', 'Sistemas Programables');
INSERT INTO materias VALUES ('dwd-1403', 'Diseño e Implementación de Sitios Web (Especialidad)');

-- CON CLAVE DUPLICADA. TODO: Hay que ver cuál es la materia correcta, y cambiar la equivocada a mano.
INSERT INTO materias VALUES ('scd-1027', 'Topicos Avanzados de Programación');
INSERT INTO materias VALUES ('aec-1061', 'Sistemas Operativos I');

INSERT INTO materias VALUES ('sch-1024', 'Taller de Administración');
INSERT INTO materias VALUES ('acc-0906', 'Fundamentos de Investigación');

/* --------------------------------------------------------

    2. ISC. Teconologías Emergentes.

-------------------------------------------------------- */
INSERT INTO materias VALUES ('acf-0901', 'Cálculo Diferencial');
INSERT INTO materias VALUES ('acf-0902', 'Cálculo Integral');
INSERT INTO materias VALUES ('acf-0904', 'Cálculo Vectorial');
INSERT INTO materias VALUES ('acf-0905', 'Ecuaciones Diferenciales');
INSERT INTO materias VALUES ('scd-1008', 'Fundamentos de Programacion');
INSERT INTO materias VALUES ('scd-1020', 'Programación Orientada a Objetos');
INSERT INTO materias VALUES ('aed-1026', 'Estructura de Datos');
INSERT INTO materias VALUES ('scc-1017', 'Métodos Numéricos');
INSERT INTO materias VALUES ('aca-0907', 'Taller de Ética');
INSERT INTO materias VALUES ('aec-1008', 'Contabilidad Financiera');
INSERT INTO materias VALUES ('scc-1005', 'Cultura Empresarial');
INSERT INTO materias VALUES ('scd-1027', 'Topicos Avanzados de Programación');
INSERT INTO materias VALUES ('aef-1041', 'Matemáticas Discretas');
INSERT INTO materias VALUES ('aec-1058', 'Química');
INSERT INTO materias VALUES ('scc-1013', 'Investigación de Operaciones');
INSERT INTO materias VALUES ('aef-1031', 'Fundamentos de Bases de Datos');
INSERT INTO materias VALUES ('acf-0903', 'Álgebra Lineal');
INSERT INTO materias VALUES ('aec-1061', 'Sistemas Operativos I');
INSERT INTO materias VALUES ('sca-1026', 'Taller de Sistemas Operativos');
INSERT INTO materias VALUES ('aef-1052', 'Probabilidad y Estadística');
INSERT INTO materias VALUES ('scf-1006', 'Física General');
INSERT INTO materias VALUES ('scd-1018', 'Principios Eléctricos y Aplicaciones Digitales');
INSERT INTO materias VALUES ('acd-0908', 'Desarrollo Sustentable');
INSERT INTO materias VALUES ('scd-1015', 'Lenguajes y Autómatas I');
INSERT INTO materias VALUES ('scd-1016', 'Lenguajes y Autómatas II');
INSERT INTO materias VALUES ('scc-1019', 'Programación Lógica y Funcional');
INSERT INTO materias VALUES ('scc-1012', 'Inteligencia Artificial');
INSERT INTO materias VALUES ('aec-1034', 'Fundamentos de Telecomunicaciones');
INSERT INTO materias VALUES ('scd-1021', 'Redes de Computadora');
INSERT INTO materias VALUES ('scd-1004', 'Comunicación y Enrutamiento de Redes de Datos');
INSERT INTO materias VALUES ('sca-1002', 'Administración de redes');
INSERT INTO materias VALUES ('ted-1404', 'Tecnologías de Virtualización (Especialidad)');
INSERT INTO materias VALUES ('sca-1025', 'Taller de Bases de Datos');
INSERT INTO materias VALUES ('scb-1001', 'Administración de Bases de Datos');
INSERT INTO materias VALUES ('aca-0909', 'Taller de Investigación I');
INSERT INTO materias VALUES ('aca-0910', 'Taller de Investigación II');
INSERT INTO materias VALUES ('ted-1405', 'Planes y Respuestas a Contingencias (Especialidad)');
INSERT INTO materias VALUES ('scd-1022', 'Simulación');
INSERT INTO materias VALUES ('aeb-1055', 'Programación Web');
INSERT INTO materias VALUES ('teb-1401', 'Programación Web II (Especialidad)');
INSERT INTO materias VALUES ('scc-1010', 'Graficación');
INSERT INTO materias VALUES ('scc-1007', 'Fundamentos de Ingeniería de Software');
INSERT INTO materias VALUES ('scd-1011', 'Ingeniería de Software');
INSERT INTO materias VALUES ('scg-1009', 'Gestión de Proyectos de Software');
INSERT INTO materias VALUES ('teb-1402', 'Programación de Bases de Datos (Especialidad)');
INSERT INTO materias VALUES ('scd-1003', 'Arquitectura de Computadoras');
INSERT INTO materias VALUES ('scc-1014', 'Lenguajes de Interfaz');
INSERT INTO materias VALUES ('scc-1023', 'Sistemas Programables');
INSERT INTO materias VALUES ('tef-1403', 'Inteligencia de Negocios (Especialidad)');

-- CON CLAVE DUPLICADA. TODO: Hay que ver cuál es la materia correcta, y cambiar la equivocada a mano.
INSERT INTO materias VALUES ('sch-1024', 'Taller de Administración');
INSERT INTO materias VALUES ('acc-0906', 'Fundamentos de Investigación');

/* --------------------------------------------------------

    Ingeniería Electrónica.

-------------------------------------------------------- */
INSERT INTO materias VALUES ('acf-0901', 'Cálculo Diferencial');
INSERT INTO materias VALUES ('acf-0902', 'Cálculo Integral');
INSERT INTO materias VALUES ('acf-0904', 'Cálculo Vectorial');
INSERT INTO materias VALUES ('acf-0905', 'Ecuaciones Diferenciales');
INSERT INTO materias VALUES ('aef-1042', 'Mecánica Clásica');
INSERT INTO materias VALUES ('aee-1051', 'Probabilidad y Estadística');
INSERT INTO materias VALUES ('aef-1020', 'Electromagnetismo');
INSERT INTO materias VALUES ('etf-1004', 'Circuitos Eléctricos I');
INSERT INTO materias VALUES ('aec-1058', 'Química');
INSERT INTO materias VALUES ('acd-0908', 'Desarrollo Sustentable');
INSERT INTO materias VALUES ('acf-0903', 'Álgebra Lineal');
INSERT INTO materias VALUES ('etp-1020', 'Marco Legal de la Empresa');
INSERT INTO materias VALUES ('aca-0907', 'Taller de Ética');
INSERT INTO materias VALUES ('etd-1021', 'Mediciones Eléctricas');
INSERT INTO materias VALUES ('etf-1017', 'Física de Semiconductores');
INSERT INTO materias VALUES ('etf-1003', 'Análisis Numérico');
INSERT INTO materias VALUES ('acc-0906', 'Fundamentos de Investigación');
INSERT INTO materias VALUES ('etf-1027', 'Tópicos Selectos de Física');
INSERT INTO materias VALUES ('etd-1024', 'Programación Estructurada');
INSERT INTO materias VALUES ('etf-1014', 'Diseño Digital');
INSERT INTO materias VALUES ('etq-1006', 'Comunicación Humana');
INSERT INTO materias VALUES ('etq-1009', 'Desarrollo Humano');
INSERT INTO materias VALUES ('etd-1025', 'Programación Visual');
INSERT INTO materias VALUES ('etf-1005', 'Circuitos Eléctricos II');
INSERT INTO materias VALUES ('aef-1009', 'Control I');
INSERT INTO materias VALUES ('aef-1010', 'Control II');
INSERT INTO materias VALUES ('etf-1007', 'Control Digital');
INSERT INTO materias VALUES ('eto-1011', 'Desarrollo y Evaluación de Proyectos');
INSERT INTO materias VALUES ('etf-1012', 'Diodos y Transistores');
INSERT INTO materias VALUES ('etf-1013', 'Diseño con Transistores');
INSERT INTO materias VALUES ('etf-1002', 'Amplificadores Operacionales');
INSERT INTO materias VALUES ('etf-1008', 'Controladores Lógicos Programables');
INSERT INTO materias VALUES ('auf-1405', 'Redes de Comunicación Industrial (Especialidad)');
INSERT INTO materias VALUES ('etf-1026', 'Teoría Electromagnética');
INSERT INTO materias VALUES ('etp-1018', 'Fundamentos Financieros');
INSERT INTO materias VALUES ('aef-1038', 'Instrumentación');
INSERT INTO materias VALUES ('etf-1016', 'Electrónica de Potencia');
INSERT INTO materias VALUES ('auf-1406', 'Tópicos Selectos de Automatización (Especialidad)');
INSERT INTO materias VALUES ('aef-1040', 'Máquinas Eléctricas');
INSERT INTO materias VALUES ('etd-1022', 'Microcrontroladores');
INSERT INTO materias VALUES ('etf-1028', 'Optoelectrónica');
INSERT INTO materias VALUES ('etr-1001', 'Administración Gerencial');
INSERT INTO materias VALUES ('etf-1015', 'Diseño Digital con VHDL');
INSERT INTO materias VALUES ('aca-0909', 'Taller de Investigación I');
INSERT INTO materias VALUES ('etf-1019', 'Introducción a las Telecomunicaciones');
INSERT INTO materias VALUES ('auf-1402', 'Adquisición de Datos (Especialidad)');
INSERT INTO materias VALUES ('eto-1010', 'Desarrollo Profesional');
INSERT INTO materias VALUES ('aca-0910', 'Taller de Investigación II');
INSERT INTO materias VALUES ('auf-1403', 'Circuitos Hidráulicos y Neumáticos (Especialidad)');
INSERT INTO materias VALUES ('auf-1401', 'Diseño Asistido Por Computadora (Especialidad)');
INSERT INTO materias VALUES ('auf-1404', 'Robótica (Especialidad)');

/* --------------------------------------------------------

    Ingeniería Mecánica.

-------------------------------------------------------- */
INSERT INTO materias VALUES ('mev-1006', 'Dibujo Mecánico');
INSERT INTO materias VALUES ('mec-1023', 'Probabiliad y Estadística');
INSERT INTO materias VALUES ('med-1010', 'Estatica');
INSERT INTO materias VALUES ('med-1020', 'Mecánica de Materiales I');
INSERT INTO materias VALUES ('acf-0901', 'Cálculo Diferencial');
INSERT INTO materias VALUES ('acf-0902', 'Cálculo Integral');
INSERT INTO materias VALUES ('acf-0904', 'Cálculo Vectorial');
INSERT INTO materias VALUES ('acf-0905', 'Ecuaciones Diferenciales');
INSERT INTO materias VALUES ('aeh-1393', 'Metrología y Normalización');
INSERT INTO materias VALUES ('acf-0903', 'Álgebra Lineal');
INSERT INTO materias VALUES ('mec-1003', 'Calidad');
INSERT INTO materias VALUES ('aed-1391', 'Dinámica');
INSERT INTO materias VALUES ('mec-1026', 'Química');
INSERT INTO materias VALUES ('mef-1013', 'Ingeniería de Materiales Metálicos');
INSERT INTO materias VALUES ('mef-1014', 'Ingeniería de Materiales No Metálicos');
INSERT INTO materias VALUES ('med-1025', 'Procesos de Manufactura');
INSERT INTO materias VALUES ('aca-0907', 'Taller de Ética');
INSERT INTO materias VALUES ('mea-1001', 'Algoritmos y Programación');
INSERT INTO materias VALUES ('aef-1020', 'Electromagnetismo');
INSERT INTO materias VALUES ('med-1030', 'Sistemas Electrónicos');
INSERT INTO materias VALUES ('acc-0906', 'Fundamentos de Investigación');
INSERT INTO materias VALUES ('mer-1024', 'Proceso Administrativo');
INSERT INTO materias VALUES ('mer-1005', 'Contabilidad y Costos');
INSERT INTO materias VALUES ('aec-1046', 'Métodos Numéricos');
INSERT INTO materias VALUES ('med-1021', 'Mecánica de Materiales II');
INSERT INTO materias VALUES ('med-1008', 'Diseño Mecánico I');
INSERT INTO materias VALUES ('med-1009', 'Diseño Mecánico II');
INSERT INTO materias VALUES ('mec-1016', 'Mantenimiento');
INSERT INTO materias VALUES ('aed-1043', 'Mecanismos');
INSERT INTO materias VALUES ('aed-1067', 'Vibraciones Mecánicas');
INSERT INTO materias VALUES ('mer-1012', 'Higiene y Seguridad Industrial');
INSERT INTO materias VALUES ('mel-1028', 'Sistemas de Generación de Energía');
INSERT INTO materias VALUES ('mef-1031', 'Termodinámica');
INSERT INTO materias VALUES ('mef-1032', 'Transferencia de Calor');
INSERT INTO materias VALUES ('mee-1017', 'Máquinas de Fluidos Compresibles');
INSERT INTO materias VALUES ('med-1027', 'Refrigeración y Aire Acondicionado');
INSERT INTO materias VALUES ('mec-1019', 'Mecánica de Fluidos');
INSERT INTO materias VALUES ('med-1029', 'Sistemas e Instalaciones Hidráulicas');
INSERT INTO materias VALUES ('mef-1018', 'Máquinas de Fluidos Incompresibles');
INSERT INTO materias VALUES ('mec-1011', 'Gestión de Proyectos');
INSERT INTO materias VALUES ('med-1004', 'Circuitos y Máquinas Eléctricas');
INSERT INTO materias VALUES ('mef-1015', 'Instrumentación y Control');
INSERT INTO materias VALUES ('mef-1002', 'Automatización Industrial');
INSERT INTO materias VALUES ('acd-0908', 'Desarrollo Sustentable');
INSERT INTO materias VALUES ('aca-0909', 'Taller de Investigación I');
INSERT INTO materias VALUES ('aca-0910', 'Taller de Investigación II');

/* --------------------------------------------------------

    Ingeniería Mecatrónica.

-------------------------------------------------------- */
INSERT INTO materias VALUES ('aec-1058', 'Química');
INSERT INTO materias VALUES ('acf-0902', 'Cálculo Integral');
INSERT INTO materias VALUES ('acf-0904', 'Cálculo Vectorial');
INSERT INTO materias VALUES ('acf-0905', 'Ecuaciones Diferenciales');
INSERT INTO materias VALUES ('acf-0901', 'Cálculo Diferencial');
INSERT INTO materias VALUES ('acf-0903', 'Álgebra Lineal');
INSERT INTO materias VALUES ('mtc-1022', 'Procesos de Fabricación');
INSERT INTO materias VALUES ('mtc-1017', 'Fundamentos de Termodinámica');
INSERT INTO materias VALUES ('aca-0907', 'Taller de Ética');
INSERT INTO materias VALUES ('mtf-1004', 'Ciencia e Ingeniería de los Materiales');
INSERT INTO materias VALUES ('aef-1020', 'Electromagnetismo');
INSERT INTO materias VALUES ('mtj-1020', 'Mecánica de Materiales');
INSERT INTO materias VALUES ('aea-1013', 'Dibujo Asistido por Computadora');
INSERT INTO materias VALUES ('mtd-1024', 'Programación Básica');
INSERT INTO materias VALUES ('mtc-1015', 'Estática');
INSERT INTO materias VALUES ('mtc-1008', 'Dinámica');
INSERT INTO materias VALUES ('aec-1047', 'Metrología y Normalización');
INSERT INTO materias VALUES ('mtc-1014', 'Estadística y Control de Calidad');
INSERT INTO materias VALUES ('aec-1046', 'Métodos Numéricos');
INSERT INTO materias VALUES ('mtj-1002', 'Análisis de Circuitos Eléctricos');
INSERT INTO materias VALUES ('acc-0906', 'Fundamentos de Investigación');
INSERT INTO materias VALUES ('mtc-1001', 'Administración y Contabilidad');
INSERT INTO materias VALUES ('acd-0908', 'Desarrollo Sustentable');
INSERT INTO materias VALUES ('aef-1040', 'Máquinas Eléctricas');
INSERT INTO materias VALUES ('mtj-1012', 'Electrónica de Potencia Aplicada');
INSERT INTO materias VALUES ('mtf-1009', 'Dinámica de Sistemas');
INSERT INTO materias VALUES ('mtj-1006', 'Control');
INSERT INTO materias VALUES ('mtf-1025', 'Robótica');
INSERT INTO materias VALUES ('mtj-1011', 'Electrónica Analógica');
INSERT INTO materias VALUES ('aef-1038', 'Instrumentación');
INSERT INTO materias VALUES ('mtd-1019', 'Manufactura Avanzada');
INSERT INTO materias VALUES ('mto-1016', 'Formulación y Evaluación de Proyectos');
INSERT INTO materias VALUES ('atf-1404', 'Redes de Comunicación Industrial (Especialidad)');
INSERT INTO materias VALUES ('aed-1043', 'Mecanismos');
INSERT INTO materias VALUES ('mtf-1010', 'Diseño de Elementos Mecánicos');
INSERT INTO materias VALUES ('mtg-1005', 'Circuitos Hidráulicos y Neumáticos');
INSERT INTO materias VALUES ('mtd-1007', 'Controladores Lógicos Programables');
INSERT INTO materias VALUES ('atf-1405', 'Tópicos Selectos de Automatización (Especialidad)');
INSERT INTO materias VALUES ('mtc-1003', 'Análisis de Fluidos');
INSERT INTO materias VALUES ('mtf-1013', 'Electrónica Digital');
INSERT INTO materias VALUES ('mtf-1018', 'Mantenimiento');
INSERT INTO materias VALUES ('atf-1401', 'Adquisición de Datos (Especialidad)');
INSERT INTO materias VALUES ('aca-0909', 'Taller de Investigación I');
INSERT INTO materias VALUES ('aed-1067', 'Vibraciones Mecánicas');
INSERT INTO materias VALUES ('mtf-1021', 'Microcontroladores');
INSERT INTO materias VALUES ('atf-1402', 'Diseño Asistido por Computadora (Especialidad)');
INSERT INTO materias VALUES ('aca-0910', 'Taller de Investigación II');
INSERT INTO materias VALUES ('mtg-1023', 'Programación Avanzada');
INSERT INTO materias VALUES ('atf-1403', 'Diseño Digital con VHDL (Especialidad)');

/* --------------------------------------------------------

    Ingeniería Industrial.

-------------------------------------------------------- */
INSERT INTO materias VALUES ('acc-0906', 'Fundamentos de Investigación');
INSERT INTO materias VALUES ('inc-1009', 'Electricidad y Electrónica Industrial');
INSERT INTO materias VALUES ('aec-1047', 'Metrología y Normalización');
INSERT INTO materias VALUES ('inc-1023', 'Procesos de Fabricación');
INSERT INTO materias VALUES ('aca-0907', 'Taller de Ética');
INSERT INTO materias VALUES ('inc-1024', 'Propiedad de los Materiales');
INSERT INTO materias VALUES ('acf-0903', 'Álgebra Lineal');
INSERT INTO materias VALUES ('inc-1013', 'Física');
INSERT INTO materias VALUES ('acf-0901', 'Cálculo Diferencial');
INSERT INTO materias VALUES ('acf-0902', 'Cálculo Integral');
INSERT INTO materias VALUES ('acf-0904', 'Cálculo Vectorial');
INSERT INTO materias VALUES ('inc-1005', 'Algoritmos y Lenguajes de Programación');
INSERT INTO materias VALUES ('inh-1029', 'Taller de Herramientas Intelectuales');
INSERT INTO materias VALUES ('inr-1017', 'Ingeniería de Sistemas');
INSERT INTO materias VALUES ('aec-1018', 'Economía');
INSERT INTO materias VALUES ('inc-1018', 'Investigación de Operaciones I');
INSERT INTO materias VALUES ('inc-1025', 'Química');
INSERT INTO materias VALUES ('aec-1053', 'Probabilidad y Estadística');
INSERT INTO materias VALUES ('aef-1024', 'Estadística Inferencial I');
INSERT INTO materias VALUES ('aef-1025', 'Estadística Inferencial II');
INSERT INTO materias VALUES ('inn-1008', 'Dibujo Industrial');
INSERT INTO materias VALUES ('inq-1006', 'Análisis de la Realidad Nacional');
INSERT INTO materias VALUES ('inj-1011', 'Estudio del Trabajo I');
INSERT INTO materias VALUES ('inj-1012', 'Estudio del Trabajo II');
INSERT INTO materias VALUES ('inc-1030', 'Taller de Liderazgo');
INSERT INTO materias VALUES ('inf-1016', 'Higiene y Seguridad Industrial');
INSERT INTO materias VALUES ('inr-1003', 'Administración de Proyectos');
INSERT INTO materias VALUES ('aca-0909', 'Taller de Investigación I');
INSERT INTO materias VALUES ('aca-0910', 'Taller de Investigación II');
INSERT INTO materias VALUES ('aed-1030', 'Formulación y Evaluación de Proyectos');
INSERT INTO materias VALUES ('inc-1014', 'Gestión de Costos');
INSERT INTO materias VALUES ('aec-1037', 'Ingeniería Económica');
INSERT INTO materias VALUES ('inc-1021', 'Planeación Financiera');
INSERT INTO materias VALUES ('inc-1026', 'Relaciones Industriales');
INSERT INTO materias VALUES ('inc-1001', 'Administración de las Operaciones I');
INSERT INTO materias VALUES ('inc-1002', 'Administración de las Operaciones II');
INSERT INTO materias VALUES ('inc-1022', 'Planeación y Diseño de Instalaciones');
INSERT INTO materias VALUES ('inc-1019', 'Investigación de Operaciones II');
INSERT INTO materias VALUES ('inc-1027', 'Simulación');
INSERT INTO materias VALUES ('inf-1028', 'Sistemas de Manufactura');
INSERT INTO materias VALUES ('inf-1007', 'Control Estadístico de la Calidad');
INSERT INTO materias VALUES ('inc-1004', 'Administración del Mantenimiento');
INSERT INTO materias VALUES ('inh-1020', 'Logística y Cadenas de Suministro');
INSERT INTO materias VALUES ('inc-1015', 'Gestión de los Sistemas de Calidad');
INSERT INTO materias VALUES ('acd-0908', 'Desarrollo Sustentable');

/* --------------------------------------------------------

    3. Ingeniería en Gestión Empresarial.

-------------------------------------------------------- */
INSERT INTO materias VALUES ('acc-0906', 'Fundamentos de Investigación');
INSERT INTO materias VALUES ('geb-0931', 'Software de Aplicación Ejecutivo');
INSERT INTO materias VALUES ('gec-0926', 'Marco Legal de las Organizaciones');
INSERT INTO materias VALUES ('gef-0922', 'Ingeniería Económica');
INSERT INTO materias VALUES ('acf-0901', 'Cálculo Diferencial');
INSERT INTO materias VALUES ('acf-0902', 'Cálculo Integral');
INSERT INTO materias VALUES ('gef-0929', 'Probabilidad y Estadística Descriptiva');
INSERT INTO materias VALUES ('geg-0910', 'Estadística Inferencial I');
INSERT INTO materias VALUES ('ged-0904', 'Cont. Orientada a los Negocios');
INSERT INTO materias VALUES ('ged-0905', 'Costos Empresariales');
INSERT INTO materias VALUES ('ged-0923', 'Inst. de Presup. Empresarial');
INSERT INTO materias VALUES ('gef-0915', 'Fund. de Gestión Empresarial');
INSERT INTO materias VALUES ('aec-1014', 'Dinámica Social');
INSERT INTO materias VALUES ('gec-0919', 'Habilidades Directivas I');
INSERT INTO materias VALUES ('gec-0920', 'Habilidades Directivas II');
INSERT INTO materias VALUES ('aca-0907', 'Taller de Ética');
INSERT INTO materias VALUES ('gef-0907', 'Economía Empresarial');
INSERT INTO materias VALUES ('gef-0909', 'Entorno Macroeconómico');
INSERT INTO materias VALUES ('gef-0914', 'Fundamentos de Química');
INSERT INTO materias VALUES ('gee-0925', 'Legislación Laboral');
INSERT INTO materias VALUES ('acf-0903', 'Álgebra Lineal');
INSERT INTO materias VALUES ('gef-0924', 'Investigación de Operaciones');
INSERT INTO materias VALUES ('gef-0912', 'Finanzas en las Organizaciones');
INSERT INTO materias VALUES ('gef-0901', 'Adm. de la Salud Seg. Ocupacional');
INSERT INTO materias VALUES ('ged-0903', 'Calidad Apda. a la Gest. Empresarial');
INSERT INTO materias VALUES ('rhm-1701', 'Gestión de Remu. y Prestaciones (Especialidad) ');
INSERT INTO materias VALUES ('rhj-1705', 'Administración de la Seg. Ind. y Salud Ocupac. (Especialidad)');
INSERT INTO materias VALUES ('geg-0911', 'Estadística Inferencial II');
INSERT INTO materias VALUES ('ged-0908', 'El Emprendedor y la Innovación');
INSERT INTO materias VALUES ('ged-0928', 'Plan de Negocios');
INSERT INTO materias VALUES ('rhm-1702', 'Psicología de Ingeniería (Especialidad)');
INSERT INTO materias VALUES ('gef-0921', 'Ingeniería de Procesos');
INSERT INTO materias VALUES ('gef-0902', 'Cadena de Suministros');
INSERT INTO materias VALUES ('geg-0918', 'Gestión del Capital Humano');
INSERT INTO materias VALUES ('aed-1015', 'Diseño Organizacional');
INSERT INTO materias VALUES ('aed-1035', 'Gestión Estratégica');
INSERT INTO materias VALUES ('rhg-1703', 'Alta Dirección (Especialidad)');
INSERT INTO materias VALUES ('aca-0909', 'Taller de Investigación I');
INSERT INTO materias VALUES ('aca-0910', 'Taller de Investigación II');
INSERT INTO materias VALUES ('acd-0908', 'Desarrollo Sustentable');
INSERT INTO materias VALUES ('rhg-1704', 'Integración del Talento Humano (Especialidad)');
INSERT INTO materias VALUES ('gef-0927', 'Mercadotecnia');
INSERT INTO materias VALUES ('gec-0930', 'Sist. de la Inf. de la Mercadotecnia');
INSERT INTO materias VALUES ('aeb-1045', 'Mercadotecnia Electrónica');

-- CON CLAVE DUPLICADA. TODO: Hay que ver cuál es la materia correcta, y cambiar la equivocada a mano.
INSERT INTO materias VALUES ('gec-0905', 'Desarrollo Humano ');
INSERT INTO materias VALUES ('gec-0909', 'Fundamentos de Física');

INSERT INTO materias VALUES ('gec-0911', 'Gestión de la Producción I');
INSERT INTO materias VALUES ('gec-0912', 'Gestión de la Producción II');

/* --------------------------------------------------------

    4. ITICs. Desarrollo Web y Aplicaciones Móviles.

-------------------------------------------------------- */
INSERT INTO materias VALUES ('acf-0901', 'Cálculo Diferencial');
INSERT INTO materias VALUES ('acf-0902', 'Cálculo Integral');
INSERT INTO materias VALUES ('tie-1018', 'Matematicas Aplicadas a la Comunicacion');
INSERT INTO materias VALUES ('tid-1004', 'Analisis de Señal y Sistemas de Comunicacion');
INSERT INTO materias VALUES ('scd-1008', 'Fundamentos de Programacion');
INSERT INTO materias VALUES ('scd-1020', 'Programación Orientada a Objetos');
INSERT INTO materias VALUES ('aed-1026', 'Estructura de Datos');
INSERT INTO materias VALUES ('tib-1024', 'Programacion II');
INSERT INTO materias VALUES ('tif-1019', 'Matematicas Discretas I');
INSERT INTO materias VALUES ('tif-1020', 'Matematicas Discretas II');
INSERT INTO materias VALUES ('tic-1002', 'Administracion Gerencial');
INSERT INTO materias VALUES ('tif-1021', 'Matematicas Para Toma de Deciciones');
INSERT INTO materias VALUES ('tip-1017', 'Introducción a las TICs');
INSERT INTO materias VALUES ('aef-1052', 'Probabilidad y Estadística');
INSERT INTO materias VALUES ('aef-1031', 'Fundamentos de Bases de Datos');
INSERT INTO materias VALUES ('aeh-1063', 'Taller de bases de Datos');
INSERT INTO materias VALUES ('aca-0907', 'Taller de Ética');
INSERT INTO materias VALUES ('tif-1009', 'Contabilidad y Costos');
INSERT INTO materias VALUES ('tic-1011', 'Electricidad y Magnetismo');
INSERT INTO materias VALUES ('tid-1008', 'Circuitos Electricos y Electronicos');
INSERT INTO materias VALUES ('acc-0906', 'Fundamentos de Investigación');
INSERT INTO materias VALUES ('acf-0903', 'Álgebra Lineal');
INSERT INTO materias VALUES ('tic-1014', 'Ingenieria de Software');
INSERT INTO materias VALUES ('tif-1013', 'Fundamentos de Redes');
INSERT INTO materias VALUES ('tif-1026', 'Redes de computadora');
INSERT INTO materias VALUES ('tif-1027', 'Redes emergentes');
INSERT INTO materias VALUES ('tif-1003', 'Administracion y Seguridad de Redes');
INSERT INTO materias VALUES ('tif-1030', 'Telecomunicaciones');
INSERT INTO materias VALUES ('tib-1025', 'Programacion Web');
INSERT INTO materias VALUES ('aeb-1011', 'Desarrollo de Aplicaciones para Dispositivos Moviles');
INSERT INTO materias VALUES ('tic-1006', 'Auditoria en Tecnologias de Informacion');
INSERT INTO materias VALUES ('dwb-1404', 'Programación Multiplataforma para Aplicaciones Móviles (Especialidad)');
INSERT INTO materias VALUES ('tif-1001', 'Administracion de Proyectos');
INSERT INTO materias VALUES ('tid-1010', 'Desarrollo de emprendedores');
INSERT INTO materias VALUES ('acd-0908', 'Desarrollo Sustentable');
INSERT INTO materias VALUES ('tih-1016', 'Interaccion Humano Computadora');
INSERT INTO materias VALUES ('dwd-1405', 'Diseño para Aplicaciones Móviles (Especialidad)');
INSERT INTO materias VALUES ('tif-1007', 'Base de Datos Distribuidas');
INSERT INTO materias VALUES ('aca-0909', 'Taller de Investigación I');
INSERT INTO materias VALUES ('aca-0910', 'Taller de Investigación II');
INSERT INTO materias VALUES ('dwb-1401', 'Programación Web II (Especialidad)');
INSERT INTO materias VALUES ('tic-1015', 'Ingenieria del Conocimiento');
INSERT INTO materias VALUES ('tic-1005', 'Arquitectura de computadoras');
INSERT INTO materias VALUES ('aec-1061', 'Sistemas Operativos I');
INSERT INTO materias VALUES ('aed-1062', 'Sistemas Operativos II');
INSERT INTO materias VALUES ('dwb-1402', 'Programación de Aplicaciones Nativas para Móviles (Especialidad)');
INSERT INTO materias VALUES ('tic-1028', 'Taller de Ingenieria de Software');
INSERT INTO materias VALUES ('tic-1029', 'Tecnologias Inalambricas');
INSERT INTO materias VALUES ('dwd-1403', 'Diseño e Implementación de Sitios Web (Especialidad)');

-- CON CLAVE DUPLICADA. TODO: Hay que ver cuál es la materia correcta, y cambiar la equivocada a mano.
INSERT INTO materias VALUES ('tic-1022', 'Negocios Electronicos I');
INSERT INTO materias VALUES ('tic-1023', 'Negocios Electronicos II');

/* --------------------------------------------------------

    5. ITICs. Tecnologías Emergentes.

-------------------------------------------------------- */
INSERT INTO materias VALUES ('acf-0901', 'Cálculo Diferencial');
INSERT INTO materias VALUES ('acf-0902', 'Cálculo Integral');
INSERT INTO materias VALUES ('tie-1018', 'Matematicas Aplicadas a la Comunicacion');
INSERT INTO materias VALUES ('tid-1004', 'Analisis de Señal y Sistemas de Comunicacion');
INSERT INTO materias VALUES ('scd-1008', 'Fundamentos de Programacion');
INSERT INTO materias VALUES ('scd-1020', 'Programación Orientada a Objetos');
INSERT INTO materias VALUES ('aed-1026', 'Estructura de Datos');
INSERT INTO materias VALUES ('tib-1024', 'Programacion II');
INSERT INTO materias VALUES ('tif-1019', 'Matematicas Discretas I');
INSERT INTO materias VALUES ('tif-1020', 'Matematicas Discretas II');
INSERT INTO materias VALUES ('tic-1002', 'Administracion Gerencial');
INSERT INTO materias VALUES ('tif-1021', 'Matematicas Para Toma de Deciciones');
INSERT INTO materias VALUES ('tip-1017', 'Introducción a las TICs');
INSERT INTO materias VALUES ('aef-1052', 'Probabilidad y Estadística');
INSERT INTO materias VALUES ('aef-1031', 'Fundamentos de Bases de Datos');
INSERT INTO materias VALUES ('aeh-1063', 'Taller de bases de Datos');
INSERT INTO materias VALUES ('aca-0907', 'Taller de Ética');
INSERT INTO materias VALUES ('tif-1009', 'Contabilidad y Costos');
INSERT INTO materias VALUES ('tic-1011', 'Electricidad y Magnetismo');
INSERT INTO materias VALUES ('tid-1008', 'Circuitos Electricos y Electronicos');
INSERT INTO materias VALUES ('acc-0906', 'Fundamentos de Investigación');
INSERT INTO materias VALUES ('acf-0903', 'Álgebra Lineal');
INSERT INTO materias VALUES ('tic-1014', 'Ingenieria de Software');
INSERT INTO materias VALUES ('tif-1013', 'Fundamentos de Redes');
INSERT INTO materias VALUES ('tif-1026', 'Redes de computadora');
INSERT INTO materias VALUES ('tif-1027', 'Redes emergentes');
INSERT INTO materias VALUES ('tif-1003', 'Administracion y Seguridad de Redes');
INSERT INTO materias VALUES ('tif-1030', 'Telecomunicaciones');
INSERT INTO materias VALUES ('tib-1025', 'Programacion Web');
INSERT INTO materias VALUES ('aeb-1011', 'Desarrollo de Aplicaciones para Dispositivos Moviles');
INSERT INTO materias VALUES ('tic-1006', 'Auditoria en Tecnologias de Informacion');
INSERT INTO materias VALUES ('ted-1404', 'Tecnologías de Virtualización (Especialidad)');
INSERT INTO materias VALUES ('tif-1001', 'Administracion de Proyectos');
INSERT INTO materias VALUES ('tid-1010', 'Desarrollo de emprendedores');
INSERT INTO materias VALUES ('acd-0908', 'Desarrollo Sustentable');
INSERT INTO materias VALUES ('tih-1016', 'Interaccion Humano Computadora');
INSERT INTO materias VALUES ('ted-1405', 'Planes y Respuestas a Contingencias (Especialidad)');
INSERT INTO materias VALUES ('tif-1007', 'Base de Datos Distribuidas');
INSERT INTO materias VALUES ('aca-0909', 'Taller de Investigación I');
INSERT INTO materias VALUES ('aca-0910', 'Taller de Investigación II');
INSERT INTO materias VALUES ('teb-1401', 'Programación Web II (Especialidad)');
INSERT INTO materias VALUES ('tic-1015', 'Ingenieria del Conocimiento');
INSERT INTO materias VALUES ('tic-1005', 'Arquitectura de computadoras');
INSERT INTO materias VALUES ('aec-1061', 'Sistemas Operativos I');
INSERT INTO materias VALUES ('aed-1062', 'Sistemas Operativos II');
INSERT INTO materias VALUES ('teb-1402', 'Programación de Bases de Datos (Especialidad)');
INSERT INTO materias VALUES ('tic-1028', 'Taller de Ingenieria de Software');
INSERT INTO materias VALUES ('tic-1029', 'Tecnologias Inalambricas');
INSERT INTO materias VALUES ('tef-1403', 'Inteligencia de Negocios (Especialidad)');

-- CON CLAVE DUPLICADA. TODO: Hay que ver cuál es la materia correcta, y cambiar la equivocada a mano.
INSERT INTO materias VALUES ('tic-1022', 'Negocios Electronicos I');
INSERT INTO materias VALUES ('tic-1023', 'Negocios Electronicos II');

/* --------------------------------------------------------

    Contador Público.

-------------------------------------------------------- */
INSERT INTO materias VALUES ('cpm-1030', 'Intr. a la Contabilidad Financiera');
INSERT INTO materias VALUES ('cpm-1012', 'Contabilidad Financiera I');
INSERT INTO materias VALUES ('cpm-1013', 'Contabilidad Financiera II');
INSERT INTO materias VALUES ('cpd-1011', 'Contabilidad de Sociedades');
INSERT INTO materias VALUES ('cpc-1001', 'Administración');
INSERT INTO materias VALUES ('aca-0907', 'Taller de Ética');
INSERT INTO materias VALUES ('cpc-1033', 'Mercadotecnia');
INSERT INTO materias VALUES ('cpd-1038', 'Sistemas de Costos Históricos.');
INSERT INTO materias VALUES ('acf-0903', 'Álgebra Lineal');
INSERT INTO materias VALUES ('cpd-1008', 'Cálculo Diferencial e Integral');
INSERT INTO materias VALUES ('cpc-1032', 'Matemáticas Financieras');
INSERT INTO materias VALUES ('cpc-1034', 'Microeconomía');
INSERT INTO materias VALUES ('cpc-1025', 'Fundamentos de Derecho');
INSERT INTO materias VALUES ('cpd-1016', 'Derecho Mercantil');
INSERT INTO materias VALUES ('cpc-1015', 'Derecho Laboral y Seguridad Social');
INSERT INTO materias VALUES ('cpc-1017', 'Derecho Tributario');
INSERT INTO materias VALUES ('cpc-1018', 'Desarrollo Humano');
INSERT INTO materias VALUES ('cpc-1019', 'Dinámica Social');
INSERT INTO materias VALUES ('cpc-1026', 'Gestión del Talento Humano');
INSERT INTO materias VALUES ('cpc-1024', 'Fundamentos de Auditoría');
INSERT INTO materias VALUES ('acc-0906', 'Fundamentos de Investigación');
INSERT INTO materias VALUES ('cpc-1022', 'Estadística Administrativa I');
INSERT INTO materias VALUES ('cpc-1023', 'Estadística Administrativa II');
INSERT INTO materias VALUES ('aca-0909', 'Taller de Investigación I');
INSERT INTO materias VALUES ('cpc-1009', 'Comunicación Humana');
INSERT INTO materias VALUES ('cpc-1040', 'Taller de Informática I');
INSERT INTO materias VALUES ('acd-0908', 'Desarrollo Sustentable');
INSERT INTO materias VALUES ('cpd-1010', 'Contabilidad Avanzada');
INSERT INTO materias VALUES ('cpd-1014', 'Contabilidad Internacional');
INSERT INTO materias VALUES ('cdo-1037', 'Seminario de Contaduría');
INSERT INTO materias VALUES ('imd-1801', 'Impuestos Especiales I (Especialidad)');
INSERT INTO materias VALUES ('imd-1803', 'Sem. de Imp. para Personas Físicas. (Especialidad)');
INSERT INTO materias VALUES ('cpc-1039', 'Sistema de Costos Predeterminados');
INSERT INTO materias VALUES ('cpf-1027', 'Gestión y Toma de Decisiones');
INSERT INTO materias VALUES ('cpc-1002', 'Administración Estratégica');
INSERT INTO materias VALUES ('imd-1802', 'Impuestos Especiales II (Especialidad)');
INSERT INTO materias VALUES ('cpc-1031', 'Macroeconomía');
INSERT INTO materias VALUES ('cpc-1003', 'Admón. de la Prod. y de las Operaciones');
INSERT INTO materias VALUES ('cph-1021', 'Elab. y Eval. de Proyectos de Inv.');
INSERT INTO materias VALUES ('cpj-1028', 'Impuestos Personas Morales');
INSERT INTO materias VALUES ('cpj-1029', 'Impuestos Personas Físicas');
INSERT INTO materias VALUES ('cpj-1035', 'Otros impuestos y Contribuciones');
INSERT INTO materias VALUES ('imd-1804', 'Sem. de Imp. para Personas Morales (Especialidad)');
INSERT INTO materias VALUES ('cpd-1006', 'Auditoría para Efectos Financieros');
INSERT INTO materias VALUES ('cpd-1007', 'Auditoría para Efectos Fiscales');
INSERT INTO materias VALUES ('imf-1805', 'Planeación Fiscal (Especialidad) ');
INSERT INTO materias VALUES ('aca-0910', 'Taller de Investigación II');
INSERT INTO materias VALUES ('cpc-1020', 'Economía Internacional');
INSERT INTO materias VALUES ('cpa-1041', 'Taller de Informática II');
INSERT INTO materias VALUES ('cpc-1005', 'Análisis e Interpretación de Estados Financieros');
INSERT INTO materias VALUES ('cpc-1036', 'Planeación Financiera');
INSERT INTO materias VALUES ('cpc-1004', 'Alternativas de Inversión y Financiamiento');