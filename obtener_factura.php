<?php
/**
 * GET api/obtener_factura.php?tipo=SERVICIO|CERTIFICADO&id=123
 */
require_once __DIR__ . '/../includes/config.php';
require_once __DIR__ . '/../modules/facturacion.php';

try {
    $tipo = strtoupper($_GET['tipo'] ?? '');
    $id   = (int)($_GET['id'] ?? 0);

    if (!in_array($tipo, ['SERVICIO', 'CERTIFICADO'], true) || $id <= 0) {
        throw new InvalidArgumentException('Parámetros inválidos.');
    }

    $fac = new Facturacion();
    $factura = $tipo === 'SERVICIO'
        ? $fac->obtenerFacturaServicio($id)
        : $fac->obtenerFacturaCertificado($id);

    facJson(['success' => true, 'factura' => $factura]);
} catch (Throwable $e) {
    error_log('[obtener_factura] ' . $e->getMessage());
    facJson(['success' => false, 'message' => $e->getMessage()], 400);
}
