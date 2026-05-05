-- ============================================
-- TABLAS DE CONFIGURACIÓN GENERAL
-- ============================================

-- Tabla de roles
CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT
);

-- Tabla de datos personales para docentes
CREATE TABLE datos_personales (
    id SERIAL PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    ci VARCHAR(10),
    email VARCHAR(150) UNIQUE,
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
    datos_personales_id INTEGER NOT NULL REFERENCES datos_personales(id),
    rol_id INTEGER NOT NULL REFERENCES roles(id),
    activo BOOLEAN DEFAULT true,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABLAS DE PROVEEDORES Y MODELOS DE IA
-- ============================================

-- Tabla de proveedores de IA
CREATE TABLE proveedores_ia (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    logo_url VARCHAR(255),
    sitio_web VARCHAR(255),
    activo BOOLEAN DEFAULT true,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE modelos_ia (
    id SERIAL PRIMARY KEY,
    proveedor_id INTEGER REFERENCES proveedores_ia(id),
    id_usuario INTEGER REFERENCES usuarios(id),
    nombre VARCHAR(100) NOT NULL UNIQUE,
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

CREATE TABLE configuracion_claude (
    id_config_claude SERIAL PRIMARY KEY,
    id_modelo_ia INTEGER UNIQUE NOT NULL REFERENCES modelos_ia(id) ON DELETE CASCADE,
    id_prompt INTEGER NOT NULL REFERENCES prompt_comparacion(id_prompt) ON DELETE RESTRICT,
    id_prompt_grupal INTEGER REFERENCES prompt_comparacion(id_prompt),
    id_prompt_eficiencia INTEGER REFERENCES prompt_eficiencia_algoritmica(id_prompt_eficiencia) ON DELETE RESTRICT,
    id_prompt_eficiencia_grupal INTEGER REFERENCES prompt_eficiencia_algoritmica(id_prompt_eficiencia),
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
    id_modelo_ia INTEGER UNIQUE NOT NULL REFERENCES modelos_ia(id) ON DELETE CASCADE,
    id_prompt INTEGER NOT NULL REFERENCES prompt_comparacion(id_prompt) ON DELETE RESTRICT,
    id_prompt_grupal INTEGER REFERENCES prompt_comparacion(id_prompt),
    id_prompt_eficiencia INTEGER REFERENCES prompt_eficiencia_algoritmica(id_prompt_eficiencia) ON DELETE RESTRICT,
    id_prompt_eficiencia_grupal INTEGER REFERENCES prompt_eficiencia_algoritmica(id_prompt_eficiencia),
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
    id_modelo_ia INTEGER UNIQUE NOT NULL REFERENCES modelos_ia(id) ON DELETE CASCADE,
    id_prompt INTEGER NOT NULL REFERENCES prompt_comparacion(id_prompt) ON DELETE RESTRICT,
    id_prompt_grupal INTEGER REFERENCES prompt_comparacion(id_prompt),
    id_prompt_eficiencia INTEGER REFERENCES prompt_eficiencia_algoritmica(id_prompt_eficiencia) ON DELETE RESTRICT,
    id_prompt_eficiencia_grupal INTEGER REFERENCES prompt_eficiencia_algoritmica(id_prompt_eficiencia),
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
    id_modelo_ia INTEGER UNIQUE NOT NULL REFERENCES modelos_ia(id) ON DELETE CASCADE,
    id_prompt INTEGER NOT NULL REFERENCES prompt_comparacion(id_prompt) ON DELETE RESTRICT,
    id_prompt_grupal INTEGER REFERENCES prompt_comparacion(id_prompt),
    id_prompt_eficiencia INTEGER REFERENCES prompt_eficiencia_algoritmica(id_prompt_eficiencia) ON DELETE RESTRICT,
    id_prompt_eficiencia_grupal INTEGER REFERENCES prompt_eficiencia_algoritmica(id_prompt_eficiencia),
    endpoint_url VARCHAR(500) NOT NULL DEFAULT 'https://api.deepseek.com/v1/chat/completions',
    api_key VARCHAR(500) NOT NULL,
    model_name VARCHAR(100) NOT NULL,
    max_tokens INTEGER DEFAULT 4000,
    temperature DECIMAL(3,2) DEFAULT 0.7,
    activo BOOLEAN DEFAULT true,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABLAS DE LENGUAJES Y COMPARACIONES
-- ============================================

-- Tabla de lenguajes de programación
CREATE TABLE lenguajes (
    id SERIAL PRIMARY KEY,
    id_usuario INTEGER REFERENCES usuarios(id),
    nombre VARCHAR(50) NOT NULL UNIQUE,
    extension VARCHAR(10),
    estado BOOLEAN DEFAULT true
);

CREATE TABLE comparaciones_individuales (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    id_modelo_ia INTEGER REFERENCES modelos_ia(id),
    lenguaje_id INTEGER NOT NULL REFERENCES lenguajes(id),
    nombre_comparacion VARCHAR(200),
    codigo_1 TEXT NOT NULL,
    codigo_2 TEXT NOT NULL,
    estado VARCHAR(20) DEFAULT 'Reciente' CHECK (estado IN ('Reciente', 'Destacado', 'Oculto')),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE comparaciones_grupales (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    id_modelo_ia INTEGER REFERENCES modelos_ia(id),
    lenguaje_id INTEGER NOT NULL REFERENCES lenguajes(id),
    nombre_comparacion VARCHAR(200),
    estado VARCHAR(20) DEFAULT 'Reciente' CHECK (estado IN ('Reciente', 'Destacado', 'Oculto')),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de códigos fuente para comparaciones grupales
CREATE TABLE codigos_fuente (
    id SERIAL PRIMARY KEY,
    comparacion_grupal_id INTEGER NOT NULL REFERENCES comparaciones_grupales(id) ON DELETE CASCADE,
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
    resumen_general TEXT,
    codigos_mas_similares TEXT,
    respuesta_completa TEXT NOT NULL,
    tokens_usados INTEGER,
    tiempo_respuesta_segundos DECIMAL(10, 2),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para comparaciones pareadas
CREATE TABLE comparaciones_pareadas (
    id_comparacion_pareada SERIAL PRIMARY KEY,
    id_resultado_similitud_grupal INTEGER NOT NULL REFERENCES resultados_similitud_grupal(id_resultado_similitud_grupal) ON DELETE CASCADE,
    codigo_a_nombre VARCHAR(255) NOT NULL,
    codigo_a_orden INTEGER NOT NULL,
    codigo_b_nombre VARCHAR(255) NOT NULL,
    codigo_b_orden INTEGER NOT NULL,
    porcentaje_similitud DECIMAL(5, 2) NOT NULL,
    nivel_similitud VARCHAR(20),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_par UNIQUE(id_resultado_similitud_grupal, codigo_a_orden, codigo_b_orden)
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

CREATE TABLE comentarios_eficiencia_individual (
    id_comentario_eficiencia SERIAL PRIMARY KEY,
    id_resultado_eficiencia_individual INTEGER NOT NULL REFERENCES resultados_eficiencia_individual(id_resultado_eficiencia_individual) ON DELETE CASCADE,
    comentario TEXT NOT NULL,
    fecha_generacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de resultados de eficiencia para comparaciones grupales
CREATE TABLE resultados_eficiencia_grupal (
    id_resultado_eficiencia_grupal SERIAL PRIMARY KEY,
    id_comparacion_grupal INTEGER NOT NULL REFERENCES comparaciones_grupales(id) ON DELETE CASCADE,
    fecha_analisis TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_codigos INTEGER NOT NULL,
    ganador INTEGER,
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
    es_ganador BOOLEAN DEFAULT false,
    es_empate BOOLEAN DEFAULT false,
    ranking_eficiencia INTEGER
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
    patrones_eficientes JSONB,
    patrones_ineficientes JSONB,
    recomendaciones_generales JSONB,
    ranking_ia JSONB,
    respuesta_completa_ia JSONB,
    fecha_analisis TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABLA PARA COMENTARIOS INDIVIDUALES DENTRO DEL ANÁLISIS GRUPAL
-- ============================================

CREATE TABLE comentarios_codigo_grupal (
    id_comentario_codigo_grupal SERIAL PRIMARY KEY,
    id_comentario_grupal INTEGER NOT NULL REFERENCES comentarios_ia_grupal(id_comentario_grupal) ON DELETE CASCADE,
    id_codigo_fuente INTEGER NOT NULL REFERENCES codigos_fuente(id) ON DELETE CASCADE,
    id_detalle_codigo_eficiencia_grupal INTEGER REFERENCES detalles_codigo_eficiencia_grupal(id_detalle_codigo_eficiencia_grupal) ON DELETE CASCADE,
    orden INTEGER NOT NULL,
    nombre_archivo VARCHAR(200),
    comentario_general TEXT NOT NULL,
    puntos_fuertes JSONB,
    puntos_debiles JSONB,
    recomendaciones JSONB,
    nota_eficiencia DECIMAL(3,1) CHECK (nota_eficiencia >= 0 AND nota_eficiencia <= 10),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- FUNCIONES DE ENCRIPTACIÓN (pgcrypto)
-- ============================================

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;

CREATE FUNCTION public.encriptar_api_key(p_api_key TEXT, p_key_password TEXT) RETURNS BYTEA
    LANGUAGE plpgsql AS $$
BEGIN
    RETURN pgp_sym_encrypt(p_api_key, p_key_password);
END;
$$;

CREATE FUNCTION public.desencriptar_api_key(p_api_key_encrypted BYTEA, p_key_password TEXT) RETURNS TEXT
    LANGUAGE plpgsql AS $$
BEGIN
    RETURN pgp_sym_decrypt(p_api_key_encrypted, p_key_password);
END;
$$;

-- ============================================
-- DATOS INICIALES
-- ============================================

INSERT INTO roles (nombre, descripcion) VALUES 
('admin', 'Administrador del sistema'),
('usuario', 'Docente');

-- ============================================
-- NOTAS PARA BACKEND (Django)
-- ============================================

-- Si tienen tablas en postgres y quieren traerlas al backend, pueden usar el siguiente comando:
-- python manage.py inspectdb > models.py

-- Crear un archivo de requerimientos para el proyecto
-- pip freeze > requirements.txt