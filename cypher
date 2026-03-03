// ============================================================
// PROYECTO III: LOGISTICS OPTIMIZER (SMART ROUTING)
// SCRIPT DE CARGA OPTIMIZADO - PERSONA 1
// ============================================================

// 1. LIMPIEZA TOTAL
// Elimina datos previos para asegurar una carga limpia
MATCH (n) DETACH DELETE n;

// 2. RESTRICCIONES E ÍNDICES (PARA EVITAR PRODUCTOS CARTESIANOS)
// El objetivo es optimizar la búsqueda de nodos por ID 
CREATE CONSTRAINT ubicacion_id_unico IF NOT EXISTS 
FOR (u:Ubicacion) REQUIRE u.id IS UNIQUE;

CREATE INDEX idx_ubicacion_id IF NOT EXISTS 
FOR (n:Ubicacion) ON (n.id);

// 3. CREACIÓN DE NODOS (ELEMENTOS DEL SISTEMA)
// Se utilizan etiquetas múltiples para evitar el "modelo relacional en grafos" 
CREATE (a1:Almacen:Ubicacion {id: 'ALM_01', nombre: 'Almacén Central', capacidad_ton: 50.0})
CREATE (p1:PuntoEntrega:Ubicacion {id: 'ENT_01', cliente: 'Tienda Norte', prioridad: 1})
CREATE (p2:PuntoEntrega:Ubicacion {id: 'ENT_02', cliente: 'Supermercado Sur', prioridad: 2})
CREATE (i1:Interseccion:Ubicacion {id: 'INT_01', zona: 'Cruce Av. Las Américas'})
CREATE (i2:Interseccion:Ubicacion {id: 'INT_02', zona: 'Redoma de Chile'});

// 4. CREACIÓN DE RELACIONES (CONECTA_A)
// Optimizadas para evitar "Cartesian Product" mediante el uso de MATCH individuales.
// Propiedades obligatorias: distancia, tiempo_estimado, estado_trafico [cite: 9]

// Ruta 1: Almacén a Intersección 1
MATCH (a:Ubicacion {id: 'ALM_01'})
MATCH (i:Ubicacion {id: 'INT_01'})
CREATE (a)-[:CONECTA_A {
    distancia: 5.5, 
    tiempo_estimado: 12, 
    estado_trafico: 0.1, 
    capacidad_max: 20.0
}]->(i);

// Ruta 2: Intersección 1 a Intersección 2
MATCH (i1:Ubicacion {id: 'INT_01'})
MATCH (i2:Ubicacion {id: 'INT_02'})
CREATE (i1)-[:CONECTA_A {
    distancia: 3.2, 
    tiempo_estimado: 8, 
    estado_trafico: 0.5, 
    capacidad_max: 12.0
}]->(i2);

// Ruta 3: Intersección 2 a Punto Entrega 1
MATCH (i2:Ubicacion {id: 'INT_02'})
MATCH (p:Ubicacion {id: 'ENT_01'})
CREATE (i2)-[:CONECTA_A {
    distancia: 2.1, 
    tiempo_estimado: 5, 
    estado_trafico: 0.8, 
    capacidad_max: 30.0
}]->(p);

// Ruta 4: Intersección 1 a Punto Entrega 2
MATCH (i1:Ubicacion {id: 'INT_01'})
MATCH (p:Ubicacion {id: 'ENT_02'})
CREATE (i1)-[:CONECTA_A {
    distancia: 7.8, 
    tiempo_estimado: 15, 
    estado_trafico: 0.2, 
    capacidad_max: 25.0
}]->(p);

// 5. VERIFICACIÓN FINAL
// Muestra el grafo cargado para comprobar las propiedades
MATCH (n)-[r:CONECTA_A]->(m) 
RETURN n.id AS Origen, r.distancia AS Distancia, r.estado_trafico AS Trafico, m.id AS Destino;
