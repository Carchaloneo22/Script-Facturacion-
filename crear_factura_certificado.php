<?php
/**
 * POST api/crear_factura_certificado.php
 * Body JSON: { id_inscripcion: 123, metodo_pago: 1|2|3 }
 */
require_once __DIR__ . '/../includes/config.php';
require_once __DIR__ . '/../modules/facturacion.php';

// facSoloSuperAdmin();  // habilita en producción

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    facJson(['success' => false, 'message' => 'Método no permitido.'], 405);
}

try {
    $in = json_decode(file_get_contents('php://input'), true) ?? [];
    $idInsc = (int)($in['id_inscripcion'] ?? 0);
    $mp     = (int)($in['metodo_pago']    ?? 0);

    if ($idInsc <= 0 || !in_array($mp, [1, 2, 3], true)) {
        throw new InvalidArgumentException('Datos incompletos o método de pago inválido.');
    }

    $fac     = new Facturacion();
    $factura = $fac->facturarCertificado($idInsc, $mp);

    facJson([
        'success' => true,
        'message' => 'Soporte de pago generado correctamente.',
        'factura' => $factura,
    ]);
} catch (Throwable $e) {
    error_log('[crear_factura_certificado] ' . $e->getMessage());
    facJson(['success' => false, 'message' => $e->getMessage()], 400);
}
