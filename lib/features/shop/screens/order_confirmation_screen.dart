// <start of features/shop/screens/order_confirmation_screen.dart>
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:net_app/app_router.dart';
import 'package:net_app/core/theme/app_theme.dart';
import 'package:net_app/core/widgets/primary_button.dart';
import 'package:net_app/data/models/order_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:io';

// Convert to StatefulWidget
class OrderConfirmationScreen extends StatefulWidget {
  final OrderModel order;
  const OrderConfirmationScreen({super.key, required this.order});

  @override
  State<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> { // Create State class
  bool _isDownloadingReceipt = false; // State variable for loading

  Future<void> _generateAndDownloadReceipt(BuildContext context) async {
    setState(() {
      _isDownloadingReceipt = true; // Start loading
    });

    final pdf = pw.Document();
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

    final fontData = await rootBundle.load("assets/fonts/NotoSans-Regular.ttf");
    final ttfRegular = pw.Font.ttf(fontData);
    final fontBoldData = await rootBundle.load("assets/fonts/NotoSans-Bold.ttf");
    final ttfBold = pw.Font.ttf(fontBoldData);
    final pdfTheme = pw.ThemeData.withFont(base: ttfRegular, bold: ttfBold);

    pdf.addPage(
      pw.MultiPage(
        theme: pdfTheme,
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context pdfContext) => [
          pw.Header( /* ... PDF Header ... */ 
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Order Receipt', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.Text('AMAZONS ENTERPRISE', style: pw.TextStyle(fontSize: 16, color: PdfColors.grey600)),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text('Order ID: ${widget.order.id}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)), // Use widget.order
          pw.Text('Order Date: ${dateFormat.format(widget.order.orderDate)}'),
          pw.Text('Customer: ${widget.order.customerName} (${widget.order.customerPhone})'),
          pw.Text('Delivery Address: ${widget.order.deliveryAddress}'),
          pw.Text('Payment Method: ${paymentMethodToString(widget.order.paymentMethod)}'),
          if (widget.order.transactionId != null) pw.Text('Transaction ID: ${widget.order.transactionId}'),
          pw.Text('Order Status: ${orderStatusToString(widget.order.status)}', style: pw.TextStyle(color: widget.order.status == OrderStatus.paid || widget.order.status == OrderStatus.delivered ? PdfColors.green : PdfColors.orange)),
          pw.Divider(height: 30),
          pw.Text('Items:', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.Table.fromTextArray(
            headers: ['Item', 'Qty', 'Price', 'Subtotal'],
            data: widget.order.items.map((item) => [ // Use widget.order
              item.product.name,
              item.quantity.toString(),
              'KSh ${item.product.price.toStringAsFixed(2)}',
              'KSh ${item.totalPrice.toStringAsFixed(2)}',
            ]).toList(),
            cellAlignment: pw.Alignment.centerLeft,
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5)
          ),
          pw.SizedBox(height: 20),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text('Total Amount: KSh ${widget.order.totalAmount.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)), // Use widget.order
          ),
          pw.SizedBox(height: 30),
          pw.Center(child: pw.Text('Thank you for your order!', style: pw.TextStyle(fontStyle: pw.FontStyle.italic))),
        ],
      ),
    );

    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/Amazons_Receipt_${widget.order.id}.pdf'; // Use widget.order
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Receipt saved to $filePath'),
            backgroundColor: AppColors.successLight,
            action: SnackBarAction(
              label: 'Open',
              onPressed: () async {
                final result = await OpenFilex.open(filePath);
                if (result.type != ResultType.done && context.mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Could not open file: ${result.message}')),
                  );
                }
              },
            ),
          ),
        );
      }
    } catch (e) {
       if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error generating receipt: $e'), backgroundColor: AppColors.errorLight),
          );
       } else {
          debugPrint("Error generating receipt (context not mounted): $e");
       }
    } finally {
      if (mounted) { // Ensure widget is still mounted before calling setState
        setState(() {
          _isDownloadingReceipt = false; // Stop loading
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('EEE, dd MMM yyyy hh:mm a');
    IconData statusIcon;
    Color statusColor;

    // Use widget.order to access order details
    switch(widget.order.status) {
        case OrderStatus.paid:
        case OrderStatus.delivered:
            statusIcon = Icons.check_circle_outline_rounded;
            statusColor = AppColors.successLight;
            break;
        case OrderStatus.processing:
        case OrderStatus.outForDelivery:
        case OrderStatus.awaitingPayment:
            statusIcon = Icons.hourglass_top_rounded;
            statusColor = AppColors.infoLight;
            break;
        case OrderStatus.pending:
             statusIcon = Icons.pending_actions_rounded;
            statusColor = AppColors.warningLight;
            break;
        case OrderStatus.failed:
        case OrderStatus.cancelled:
            statusIcon = Icons.error_outline_rounded;
            statusColor = AppColors.errorLight;
            break;
    }


    return Scaffold(
      appBar: AppBar(title: const Text('Order Confirmation'), automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(statusIcon, size: 80, color: statusColor),
              const SizedBox(height: AppDimensions.md),
              Text(
                widget.order.status == OrderStatus.paid || widget.order.status == OrderStatus.processing || widget.order.status == OrderStatus.pending
                    ? 'Thank You! Your Order is Confirmed!'
                    : 'Order Status Update',
                style: theme.textTheme.displaySmall?.copyWith(fontSize: 22, color: statusColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.sm),
              Text('Order ID: ${widget.order.id}', style: theme.textTheme.titleMedium),
              Text('Date: ${dateFormat.format(widget.order.orderDate)}', style: theme.textTheme.bodyLarge),
              Text('Status: ${orderStatusToString(widget.order.status)}', style: theme.textTheme.titleLarge?.copyWith(color: statusColor, fontWeight: FontWeight.bold)),
              if (widget.order.paymentMethod == PaymentMethod.stkPush && widget.order.transactionId != null)
                 Text('M-PESA TXN ID: ${widget.order.transactionId}', style: theme.textTheme.bodyMedium),
              const SizedBox(height: AppDimensions.lg),
              const Divider(),
              const SizedBox(height: AppDimensions.lg),
              Text('Total Amount: KSh ${widget.order.totalAmount.toStringAsFixed(2)}', style: theme.textTheme.headlineSmall),
              const SizedBox(height: AppDimensions.lg),
              
              ElevatedButton.icon(
                icon: _isDownloadingReceipt 
                    ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5, color: theme.colorScheme.onPrimary))
                    : const Icon(Icons.receipt_long_outlined),
                label: Text(_isDownloadingReceipt ? 'Generating...' : 'Download Receipt'),
                onPressed: _isDownloadingReceipt ? null : () => _generateAndDownloadReceipt(context), // Disable button while loading
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg, vertical: AppDimensions.md),
                ),
              ),
              const SizedBox(height: AppDimensions.sm),
              TextButton.icon(
                icon: const Icon(Icons.track_changes_outlined),
                label: const Text('Track Order (Coming Soon)'),
                onPressed: () {
                     ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Order tracking is not yet available.')),
                    );
                },
              ),
              const SizedBox(height: AppDimensions.xl),
              PrimaryButton(
                text: 'Continue Shopping',
                onPressed: () {
                  Navigator.of(context).popUntil(ModalRoute.withName(AppRouter.shopRoute));
                },
              ),
               const SizedBox(height: AppDimensions.md),
               TextButton(
                child: const Text('Go to Main Menu'),
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.mainRoute, (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// <end of features/shop/screens/order_confirmation_screen.dart>