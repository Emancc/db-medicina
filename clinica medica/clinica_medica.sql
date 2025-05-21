-- Tabla: Pacientes
CREATE TABLE Pacientes (
    PacienteID INT PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(100) NOT NULL,
    Apellido VARCHAR(100) NOT NULL,
    FechaNacimiento DATE,
    Genero ENUM('Masculino', 'Femenino', 'Otro'),
    Direccion VARCHAR(255),
    Telefono VARCHAR(20),
    Email VARCHAR(100),
    NumeroHistoriaClinica VARCHAR(20) UNIQUE NOT NULL,
    FechaRegistro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla: PersonalMedico
CREATE TABLE PersonalMedico (
    MedicoID INT PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(100) NOT NULL,
    Apellido VARCHAR(100) NOT NULL,
    Especialidad VARCHAR(100),
    NumeroColegiado VARCHAR(20) UNIQUE,
    Telefono VARCHAR(20),
    Email VARCHAR(100)
);

-- Tabla: Especialidades
CREATE TABLE Especialidades (
    EspecialidadID INT PRIMARY KEY AUTO_INCREMENT,
    NombreEspecialidad VARCHAR(100) UNIQUE NOT NULL,
    Descripcion TEXT
);

-- Tabla: Citas
CREATE TABLE Citas (
    CitaID INT PRIMARY KEY AUTO_INCREMENT,
    PacienteID INT NOT NULL,
    MedicoID INT NOT NULL,
    FechaHora DATETIME NOT NULL,
    MotivoConsulta TEXT,
    Estado ENUM('Pendiente', 'Confirmada', 'Cancelada', 'Completada') DEFAULT 'Pendiente',
    FechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (PacienteID) REFERENCES Pacientes(PacienteID),
    FOREIGN KEY (MedicoID) REFERENCES PersonalMedico(MedicoID)
);

-- Tabla: HistorialClinico
CREATE TABLE HistorialClinico (
    HistorialID INT PRIMARY KEY AUTO_INCREMENT,
    PacienteID INT NOT NULL,
    FechaConsulta DATETIME NOT NULL,
    MedicoID INT NOT NULL,
    Diagnostico TEXT,
    Tratamiento TEXT,
    NotasAdicionales TEXT,
    FOREIGN KEY (PacienteID) REFERENCES Pacientes(PacienteID),
    FOREIGN KEY (MedicoID) REFERENCES PersonalMedico(MedicoID)
);

-- Tabla: Diagnosticos
CREATE TABLE Diagnosticos (
    DiagnosticoID INT PRIMARY KEY AUTO_INCREMENT,
    NombreDiagnostico VARCHAR(255) UNIQUE NOT NULL,
    CodigoCIE VARCHAR(10) UNIQUE
);

-- Tabla: HistorialDiagnosticos
CREATE TABLE HistorialDiagnosticos (
    HistorialDiagnosticoID INT PRIMARY KEY AUTO_INCREMENT,
    HistorialID INT NOT NULL,
    DiagnosticoID INT NOT NULL,
    FOREIGN KEY (HistorialID) REFERENCES HistorialClinico(HistorialID),
    FOREIGN KEY (DiagnosticoID) REFERENCES Diagnosticos(DiagnosticoID),
    UNIQUE KEY (HistorialID, DiagnosticoID)
);

-- Tabla: Medicamentos
CREATE TABLE Medicamentos (
    MedicamentoID INT PRIMARY KEY AUTO_INCREMENT,
    NombreComercial VARCHAR(255) NOT NULL,
    PrincipioActivo VARCHAR(255),
    Dosis VARCHAR(50),
    FormaFarmaceutica VARCHAR(100)
);

-- Tabla: Prescripciones
CREATE TABLE Prescripciones (
    PrescripcionID INT PRIMARY KEY AUTO_INCREMENT,
    HistorialID INT NOT NULL,
    MedicamentoID INT NOT NULL,
    DosisPrescrita VARCHAR(50),
    Frecuencia VARCHAR(100),
    Duracion VARCHAR(100),
    Instrucciones TEXT,
    FechaPrescripcion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (HistorialID) REFERENCES HistorialClinico(HistorialID),
    FOREIGN KEY (MedicamentoID) REFERENCES Medicamentos(MedicamentoID)
);

-- Tabla: Procedimientos
CREATE TABLE Procedimientos (
    ProcedimientoID INT PRIMARY KEY AUTO_INCREMENT,
    NombreProcedimiento VARCHAR(255) UNIQUE NOT NULL,
    Descripcion TEXT,
    CodigoCPT VARCHAR(10) UNIQUE
);

-- Tabla: HistorialProcedimientos
CREATE TABLE HistorialProcedimientos (
    HistorialProcedimientoID INT PRIMARY KEY AUTO_INCREMENT,
    HistorialID INT NOT NULL,
    ProcedimientoID INT NOT NULL,
    FechaRealizacion DATETIME,
    Notas TEXT,
    MedicoID INT,
    FOREIGN KEY (HistorialID) REFERENCES HistorialClinico(HistorialID),
    FOREIGN KEY (ProcedimientoID) REFERENCES Procedimientos(ProcedimientoID),
    FOREIGN KEY (MedicoID) REFERENCES PersonalMedico(MedicoID),
    UNIQUE KEY (HistorialID, ProcedimientoID)
);

-- Tabla: ResultadosLaboratorio
CREATE TABLE ResultadosLaboratorio (
    ResultadoID INT PRIMARY KEY AUTO_INCREMENT,
    HistorialID INT NOT NULL,
    TipoPrueba VARCHAR(255) NOT NULL,
    FechaPrueba DATETIME NOT NULL,
    Resultados TEXT,
    Unidades VARCHAR(50),
    ValoresReferencia VARCHAR(255),
    Notas TEXT,
    FOREIGN KEY (HistorialID) REFERENCES HistorialClinico(HistorialID)
);

-- Tabla: Facturas
CREATE TABLE Facturas (
    FacturaID INT PRIMARY KEY AUTO_INCREMENT,
    PacienteID INT NOT NULL,
    FechaEmision DATE NOT NULL,
    FechaVencimiento DATE,
    Estado ENUM('Pendiente', 'Pagada', 'Anulada') DEFAULT 'Pendiente',
    Total DECIMAL(10, 2) NOT NULL,
    Notas TEXT,
    FechaPago DATE,
    MetodoPago VARCHAR(100),
    FOREIGN KEY (PacienteID) REFERENCES Pacientes(PacienteID)
);

-- Tabla: DetallesFactura
CREATE TABLE DetallesFactura (
    DetalleID INT PRIMARY KEY AUTO_INCREMENT,
    FacturaID INT NOT NULL,
    Descripcion VARCHAR(255) NOT NULL,
    Cantidad INT NOT NULL DEFAULT 1,
    PrecioUnitario DECIMAL(10, 2) NOT NULL,
    Subtotal DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (FacturaID) REFERENCES Facturas(FacturaID)
);

-- Tabla: Usuarios
CREATE TABLE Usuarios (
    UsuarioID INT PRIMARY KEY AUTO_INCREMENT,
    NombreUsuario VARCHAR(50) UNIQUE NOT NULL,
    Contrasena VARCHAR(255) NOT NULL,
    Rol ENUM('Administrador', 'Medico', 'Recepcionista') NOT NULL,
    MedicoID INT NULL,
    FechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UltimoLogin TIMESTAMP,
    FOREIGN KEY (MedicoID) REFERENCES PersonalMedico(MedicoID)
);

-- Tabla: Roles
CREATE TABLE Roles (
    RolID INT PRIMARY KEY AUTO_INCREMENT,
    NombreRol VARCHAR(50) UNIQUE NOT NULL,
    Descripcion TEXT
);

-- Tabla: Permisos
CREATE TABLE Permisos (
    PermisoID INT PRIMARY KEY AUTO_INCREMENT,
    NombrePermiso VARCHAR(50) UNIQUE NOT NULL,
    Descripcion TEXT
);

-- Tabla: RolesPermisos
CREATE TABLE RolesPermisos (
    RolPermisoID INT PRIMARY KEY AUTO_INCREMENT,
    RolID INT NOT NULL,
    PermisoID INT NOT NULL,
    FOREIGN KEY (RolID) REFERENCES Roles(RolID),
    FOREIGN KEY (PermisoID) REFERENCES Permisos(PermisoID),
    UNIQUE KEY (RolID, PermisoID)
);

-- Tabla: Auditoria
CREATE TABLE Auditoria (
    AuditoriaID INT PRIMARY KEY AUTO_INCREMENT,
    UsuarioID INT,
    TablaAfectada VARCHAR(100) NOT NULL,
    RegistroAfectadoID INT,
    TipoEvento VARCHAR(50) NOT NULL,
    FechaHora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Detalles JSON,
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)
);

-- Tabla: ParametrosSistema
CREATE TABLE ParametrosSistema (
    ParametroID INT PRIMARY KEY AUTO_INCREMENT,
    NombreParametro VARCHAR(100) UNIQUE NOT NULL,
    ValorParametro VARCHAR(255),
    Descripcion TEXT
);

-- Tabla: NotasInternas
CREATE TABLE NotasInternas (
    NotaID INT PRIMARY KEY AUTO_INCREMENT,
    UsuarioID INT NOT NULL,
    FechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Contenido TEXT NOT NULL,
    RelacionTabla VARCHAR(100),
    RelacionID INT,
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)
);

-- Tabla: Recordatorios
CREATE TABLE Recordatorios (
    RecordatorioID INT PRIMARY KEY AUTO_INCREMENT,
    UsuarioID INT NOT NULL,
    FechaHoraRecordatorio DATETIME NOT NULL,
    Mensaje TEXT NOT NULL,
    Estado ENUM('Pendiente', 'Completado', 'Cancelado') DEFAULT 'Pendiente',
    FechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    RelacionTabla VARCHAR(100),
    RelacionID INT,
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)
);