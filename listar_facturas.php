<?php
/**
 * GET api/listar_facturas.php
 * Filtros opcionales: tipo, estado, desde, hasta, q, limit, offset
 */
require_once __DIR__ . '/../includes/config.php';
require_once __DIR__ . '/../modules/facturacion.php';

// facSoloSuperAdmin(); // habilita en producción

try {
    $fac = new Facturacion();

    $filtros = [
        'tipo'   => $_GET['tipo']   ?? null,
        'estado' => $_GET['estado'] ?? null,
        'desde'  => $_GET['desde']  ?? null,
        'hasta'  => $_GET['hasta']  ?? null,
        'q'      => $_GET['q']      ?? null,
        'limit'  => max(1, min(200, (int)($_GET['limit']  ?? 50))),
        'offset' => max(0, (int)($_GET['offset'] ?? 0)),
    ];

    facJson([
        'success'       => true,
        'data'          => $fac->listarFacturas($filtros),
        'estadisticas'  => $fac->estadisticas(),
    ]);
} catch (Throwable $e) {
    error_log('[listar_facturas] ' . $e->getMessage());
    facJson(['success' => false, 'message' => $e->getMessage()], 500);
}
