-- ============================================
-- TABLAS DE CONFIGURACIÓN GENERAL
-- ============================================

-- Tabla de roles
CREATE TABLE roles (
    id_rol SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT
);

-- Tabla de datos personales para docentes
CREATE TABLE datos_personales (
    id SERIAL PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    ci VARCHAR(10) NOT NULL UNIQUE,
    email VARCHAR(150) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    institucion VARCHAR(200) NOT NULL,
    facultad_area VARCHAR(150),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(20) DEFAULT 'activo' CHECK (estado IN ('activo', 'inactivo'))
);

-- Tabla de usuarios
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    usuario VARCHAR(50) NOT NULL UNIQUE,
    contrasenia VARCHAR(255) NOT NULL,
    id_datos_personales INTEGER NOT NULL REFERENCES datos_personales(id_datos_personales) ON DELETE CASCADE,
    id_rol INTEGER NOT NULL REFERENCES roles(id_rol),
    activo BOOLEAN DEFAULT true,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABLAS DE PROVEEDORES Y MODELOS DE IA
-- ============================================

-- Tabla de proveedores de IA
CREATE TABLE proveedores_ia (
    id_proveedor SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    logo_url VARCHAR(255),
    sitio_web VARCHAR(255),
    activo BOOLEAN DEFAULT true,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE modelos_ia (
    id_modelo_ia SERIAL PRIMARY KEY,
    id_proveedor INTEGER REFERENCES proveedores_ia(id_proveedor),
    id_usuario INTEGER NOT NULL REFERENCES usuarios(id),
    nombre VARCHAR(100) NOT NULL,
    version VARCHAR(50),
    descripcion TEXT,
    color_ia VARCHAR(7),
    imagen_ia BYTEA,
    activo BOOLEAN DEFAULT true,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    recomendado BOOLEAN DEFAULT false
);

CREATE TABLE prompt_comparacion (
    id_prompt SERIAL PRIMARY KEY,
    template_prompt TEXT NOT NULL,
    descripcion TEXT,
    version VARCHAR(20),
    tipo VARCHAR(20) CHECK (tipo IN ('individual', 'grupal')) DEFAULT 'individual',
    activo BOOLEAN DEFAULT true,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE configuracion_claude (
    id_config_claude SERIAL PRIMARY KEY,
    id_modelo_ia INTEGER UNIQUE NOT NULL REFERENCES modelos_ia(id_modelo_ia) ON DELETE CASCADE,
    id_prompt INTEGER NOT NULL REFERENCES prompt_comparacion(id_prompt) ON DELETE RESTRICT,
    id_prompt_grupal INTEGER REFERENCES prompt_comparacion(id_prompt) ON DELETE RESTRICT,
    id_prompt_eficiencia INTEGER REFERENCES prompt_eficiencia_algoritmica(id_prompt_eficiencia) ON DELETE RESTRICT,
    id_prompt_eficiencia_grupal INTEGER REFERENCES prompt_eficiencia_algoritmica(id_prompt_eficiencia) ON DELETE RESTRICT,
    endpoint_url VARCHAR(500) NOT NULL DEFAULT 'https://api.anthropic.com/v1/messages',
    api_key VARCHAR(500) NOT NULL,
    model_name VARCHAR(100) NOT NULL,
    max_tokens INTEGER DEFAULT 4000,
    anthropic_version VARCHAR(20) DEFAULT '2023-06-01',
    activo BOOLEAN DEFAULT true,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE configuracion_openai (
    id_config_openai SERIAL PRIMARY KEY,
    id_modelo_ia INTEGER UNIQUE NOT NULL REFERENCES modelos_ia(id_modelo_ia) ON DELETE CASCADE,
    id_prompt INTEGER NOT NULL REFERENCES prompt_comparacion(id_prompt) ON DELETE RESTRICT,
    id_prompt_grupal INTEGER REFERENCES prompt_comparacion(id_prompt) ON DELETE RESTRICT,
    id_prompt_eficiencia INTEGER REFERENCES prompt_eficiencia_algoritmica(id_prompt_eficiencia) ON DELETE RESTRICT,
    id_prompt_eficiencia_grupal INTEGER REFERENCES prompt_eficiencia_algoritmica(id_prompt_eficiencia) ON DELETE RESTRICT,
    endpoint_url VARCHAR(500) NOT NULL DEFAULT 'https://api.openai.com/v1/chat/completions',
    api_key VARCHAR(500) NOT NULL,
    model_name VARCHAR(100) NOT NULL,
    max_tokens INTEGER DEFAULT 4000,
    temperature DECIMAL(3,2) DEFAULT 0.7,
    activo BOOLEAN DEFAULT true,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE configuracion_gemini (
    id_config_gemini SERIAL PRIMARY KEY,
    id_modelo_ia INTEGER UNIQUE NOT NULL REFERENCES modelos_ia(id_modelo_ia) ON DELETE CASCADE,
    id_prompt INTEGER NOT NULL REFERENCES prompt_comparacion(id_prompt) ON DELETE RESTRICT,
    id_prompt_grupal INTEGER REFERENCES prompt_comparacion(id_prompt) ON DELETE RESTRICT,
    id_prompt_eficiencia INTEGER REFERENCES prompt_eficiencia_algoritmica(id_prompt_eficiencia) ON DELETE RESTRICT,
    id_prompt_eficiencia_grupal INTEGER REFERENCES prompt_eficiencia_algoritmica(id_prompt_eficiencia) ON DELETE RESTRICT,
    endpoint_url VARCHAR(500) NOT NULL DEFAULT 'https://generativelanguage.googleapis.com/v1beta/models',
    api_key VARCHAR(500) NOT NULL,
    model_name VARCHAR(100) NOT NULL,
    max_tokens INTEGER DEFAULT 4000,
    temperature DECIMAL(3,2) DEFAULT 0.7,
    activo BOOLEAN DEFAULT true,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE configuracion_deepseek (
    id_config_deepseek SERIAL PRIMARY KEY,
    id_modelo_ia INTEGER UNIQUE NOT NULL REFERENCES modelos_ia(id_modelo_ia) ON DELETE CASCADE,
    id_prompt INTEGER NOT NULL REFERENCES prompt_comparacion(id_prompt) ON DELETE RESTRICT,
    id_prompt_grupal INTEGER REFERENCES prompt_comparacion(id_prompt) ON DELETE RESTRICT,
    id_prompt_eficiencia INTEGER REFERENCES prompt_eficiencia_algoritmica(id_prompt_eficiencia) ON DELETE RESTRICT,
    id_prompt_eficiencia_grupal INTEGER REFERENCES prompt_eficiencia_algoritmica(id_prompt_eficiencia) ON DELETE RESTRICT,
    endpoint_url VARCHAR(500) NOT NULL DEFAULT 'https://api.deepseek.com/v1/chat/completions',
    api_key VARCHAR(500) NOT NULL,
    model_name VARCHAR(100) NOT NULL,
    max_tokens INTEGER DEFAULT 4000,
    temperature DECIMAL(3,2) DEFAULT 0.7,
    activo BOOLEAN DEFAULT true,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE prompt_eficiencia_algoritmica (
    id_prompt_eficiencia SERIAL PRIMARY KEY,
    template_prompt TEXT NOT NULL,
    descripcion TEXT,
    version VARCHAR(20),
    tipo_analisis VARCHAR(50) CHECK (tipo_analisis IN ('individual', 'grupal')),
    activo BOOLEAN DEFAULT true,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE comentarios_eficiencia_individual (
    id_comentario_eficiencia SERIAL PRIMARY KEY,
    id_resultado_eficiencia_individual INTEGER NOT NULL REFERENCES resultados_eficiencia_individual(id_resultado_eficiencia_individual) ON DELETE CASCADE,
    comentario TEXT NOT NULL,
    fecha_generacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABLAS DE LENGUAJES Y COMPARACIONES
-- ============================================

-- Tabla de lenguajes de programación
CREATE TABLE lenguajes (
    id_lenguaje SERIAL PRIMARY KEY,
    id_usuario INTEGER REFERENCES usuarios(id),
    nombre VARCHAR(50) NOT NULL UNIQUE,
    extension VARCHAR(10) NOT NULL UNIQUE,
    estado BOOLEAN DEFAULT true
);

CREATE TABLE comparaciones_individuales (
    id SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL REFERENCES usuarios(id),
    id_modelo_ia INTEGER REFERENCES modelos_ia(id_modelo_ia),
    id_lenguaje INTEGER NOT NULL REFERENCES lenguajes(id_lenguaje),
    nombre_comparacion VARCHAR(200),
    codigo_1 TEXT NOT NULL,
    codigo_2 TEXT NOT NULL,
    estado VARCHAR(20) DEFAULT 'Reciente',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE comparaciones_grupales (
    id_comparacion_grupal SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL REFERENCES usuarios(id),
    id_modelo_ia INTEGER REFERENCES modelos_ia(id),
    id_lenguaje INTEGER NOT NULL REFERENCES lenguajes(id),
    nombre_comparacion VARCHAR(200),
    estado VARCHAR(20) DEFAULT 'Reciente',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de códigos fuente para comparaciones grupales
CREATE TABLE codigos_fuente (
    id_codigo_fuente SERIAL PRIMARY KEY,
    id_comparacion_grupal INTEGER NOT NULL REFERENCES comparaciones_grupales(id_comparacion_grupal) ON DELETE CASCADE,
    codigo TEXT NOT NULL,
    nombre_archivo VARCHAR(200),
    orden INTEGER
);

-- ============================================
-- TABLAS DE RESULTADOS
-- ============================================

-- Tabla de resultados de similitud para comparaciones individuales
CREATE TABLE resultados_similitud_individual (
    id_resultado_similitud_individual SERIAL PRIMARY KEY,
    id_comparacion_individual INTEGER NOT NULL REFERENCES comparaciones_individuales(id),
    porcentaje_similitud INT NOT NULL,
    explicacion TEXT
);

-- Tabla de resultados de similitud para comparaciones grupales
CREATE TABLE resultados_similitud_grupal (
    id_resultado_similitud_grupal SERIAL PRIMARY KEY,
    id_comparacion_grupal INTEGER NOT NULL REFERENCES comparaciones_grupales(id) ON DELETE CASCADE,
    respuesta_completa TEXT NOT NULL,
    tokens_usados INTEGER,
    tiempo_respuesta_segundos DECIMAL(10, 2)
);

CREATE TABLE resultados_eficiencia_individual (
    id_resultado_eficiencia_individual SERIAL PRIMARY KEY,
    id_comparacion_individual INTEGER NOT NULL REFERENCES comparaciones_individuales(id),
    codigo_1_complejidad_temporal VARCHAR(50) NOT NULL,
    codigo_1_complejidad_espacial VARCHAR(50) NOT NULL,
    codigo_1_nivel_anidamiento INTEGER DEFAULT 0,
    codigo_1_patrones_detectados JSONB,
    codigo_1_estructuras_datos JSONB,
    codigo_1_confianza_analisis VARCHAR(50),
    codigo_2_complejidad_temporal VARCHAR(50) NOT NULL,
    codigo_2_complejidad_espacial VARCHAR(50) NOT NULL,
    codigo_2_nivel_anidamiento INTEGER DEFAULT 0,
    codigo_2_patrones_detectados JSONB,
    codigo_2_estructuras_datos JSONB,
    codigo_2_confianza_analisis VARCHAR(50),
    ganador VARCHAR(20) CHECK (ganador IN ('codigo_1', 'codigo_2', 'empate')),
    lenguaje VARCHAR(50),
    lenguaje_analizado VARCHAR(50),
    fecha_analisis TIMESTAMP
);

-- Tabla de resultados de eficiencia para comparaciones grupales
CREATE TABLE resultados_eficiencia_grupal (
    id_resultado_eficiencia_grupal SERIAL PRIMARY KEY,
    id_comparacion_grupal INTEGER NOT NULL REFERENCES comparaciones_grupales(id) ON DELETE CASCADE,
    fecha_analisis TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_codigos INTEGER NOT NULL,
    ganador INTEGER, -- orden del código ganador (1, 2, 3, etc.) o NULL si empate
    tipo_ganador VARCHAR(20) CHECK (tipo_ganador IN ('unico', 'empate_multiple', 'empate_todos')),
    complejidad_temporal_mejor VARCHAR(50),
    complejidad_temporal_peor VARCHAR(50),
    nivel_anidamiento_maximo INTEGER,
    nivel_anidamiento_minimo INTEGER,
    confianza_analisis_general VARCHAR(50)
);


CREATE TABLE detalles_codigo_eficiencia_grupal (
    id_detalle_codigo_eficiencia_grupal SERIAL PRIMARY KEY,
    id_resultado_eficiencia_grupal INTEGER NOT NULL REFERENCES resultados_eficiencia_grupal(id_resultado_eficiencia_grupal) ON DELETE CASCADE,
    id_codigo_fuente INTEGER NOT NULL REFERENCES codigos_fuente(id) ON DELETE CASCADE,
    orden INTEGER NOT NULL,
    complejidad_temporal VARCHAR(50) NOT NULL,
    complejidad_espacial VARCHAR(50) NOT NULL,
    nivel_anidamiento INTEGER DEFAULT 0,
    patrones_detectados JSONB,
    estructuras_datos JSONB,
    confianza_analisis VARCHAR(50),
    es_ganador BOOLEAN DEFAULT FALSE,
    es_empate BOOLEAN DEFAULT FALSE,
    ranking_eficiencia INTEGER -- 1 es el más eficiente
);

CREATE TABLE comentarios_ia_grupal (
    id_comentario_grupal SERIAL PRIMARY KEY,
    id_comparacion_grupal INTEGER NOT NULL REFERENCES comparaciones_grupales(id) ON DELETE CASCADE,
    id_resultado_eficiencia_grupal INTEGER NOT NULL REFERENCES resultados_eficiencia_grupal(id_resultado_eficiencia_grupal) ON DELETE CASCADE,
    id_prompt_eficiencia INTEGER REFERENCES prompt_eficiencia_algoritmica(id_prompt_eficiencia),
    resumen_comparativo TEXT,
    mejor_codigo_orden INTEGER,
    mejor_codigo_razon TEXT,
    peor_codigo_orden INTEGER,
    peor_codigo_razon TEXT,
    patrones_eficientes JSONB, -- Array de strings
    patrones_ineficientes JSONB, -- Array de strings
    recomendaciones_generales JSONB, -- Array de strings
    ranking_ia JSONB, -- Array con el orden [1, 3, 2, ...]
    respuesta_completa_ia JSONB,
    fecha_analisis TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 4. TABLA PARA COMENTARIOS INDIVIDUALES DENTRO DEL ANÁLISIS GRUPAL
-- =====================================================

CREATE TABLE comentarios_codigo_grupal (
    id_comentario_codigo_grupal SERIAL PRIMARY KEY,
    id_comentario_grupal INTEGER NOT NULL REFERENCES comentarios_ia_grupal(id_comentario_grupal) ON DELETE CASCADE,
    id_codigo_fuente INTEGER NOT NULL REFERENCES codigos_fuente(id) ON DELETE CASCADE,
    id_detalle_codigo_eficiencia_grupal INTEGER REFERENCES detalles_codigo_eficiencia_grupal(id_detalle_codigo_eficiencia_grupal) ON DELETE CASCADE,
    orden INTEGER NOT NULL,
    nombre_archivo VARCHAR(200),
    comentario_general TEXT NOT NULL,
    puntos_fuertes JSONB, -- Array de strings
    puntos_debiles JSONB, -- Array de strings
    recomendaciones JSONB, -- Array de strings
    nota_eficiencia DECIMAL(3,1) CHECK (nota_eficiencia >= 0 AND nota_eficiencia <= 10),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insertar algunos roles básicos
INSERT INTO roles (nombre, descripcion) VALUES 
('admin', 'Administrador del sistema'),
('usuario', 'Docente')


-- Si tienen tablas en postgres y quieren traerlas al backend, pueden usar el siguiente comando:
python manage.py inspectdb > models.py

-- Crear un archivo de requerimientos para el proyecto
pip freeze > requirements.txt