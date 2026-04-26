<?php
/**
 * POST api/anular_factura.php
 * Body JSON: { tipo: 'SERVICIO'|'CERTIFICADO', id: 123, motivo: '...' }
 */
require_once __DIR__ . '/../includes/config.php';
require_once __DIR__ . '/../modules/facturacion.php';

// facSoloSuperAdmin();  // habilita en producción

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    facJson(['success' => false, 'message' => 'Método no permitido.'], 405);
}

try {
    $in     = json_decode(file_get_contents('php://input'), true) ?? [];
    $tipo   = strtoupper($in['tipo']    ?? '');
    $id     = (int)($in['id']           ?? 0);
    $motivo = trim($in['motivo']        ?? '');

    if (!in_array($tipo, ['SERVICIO','CERTIFICADO'], true) || $id <= 0) {
        throw new InvalidArgumentException('Parámetros inválidos.');
    }

    (new Facturacion())->anular($tipo, $id, $motivo);

    facJson(['success' => true, 'message' => 'Soporte anulado correctamente.']);
} catch (Throwable $e) {
    error_log('[anular_factura] ' . $e->getMessage());
    facJson(['success' => false, 'message' => $e->getMessage()], 400);
}
