<?php
/**
 * GET api/listar_inscripciones_pagables.php?q=...
 * Devuelve inscripciones con progreso=100% y certificado_pagado=FALSE.
 */
require_once __DIR__ . '/../includes/config.php';
require_once __DIR__ . '/../modules/facturacion.php';

try {
    $fac = new Facturacion();
    $lista = $fac->inscripcionesPagables($_GET['q'] ?? null);
    facJson(['success' => true, 'data' => $lista]);
} catch (Throwable $e) {
    error_log('[listar_inscripciones_pagables] ' . $e->getMessage());
    facJson(['success' => false, 'message' => $e->getMessage()], 500);
}
