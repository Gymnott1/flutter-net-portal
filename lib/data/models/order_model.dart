// <start of data/models/order_model.dart>
import 'package:net_app/data/models/cart_item_model.dart';

enum PaymentMethod { stkPush, payOnDelivery }
enum OrderStatus { pending, processing, awaitingPayment, paid, outForDelivery, delivered, cancelled, failed }

String paymentMethodToString(PaymentMethod method) {
  switch (method) {
    case PaymentMethod.stkPush: return "M-PESA STK Push";
    case PaymentMethod.payOnDelivery: return "Pay on Delivery";
  }
}
String orderStatusToString(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending: return "Pending Confirmation";
    case OrderStatus.processing: return "Processing";
    case OrderStatus.awaitingPayment: return "Awaiting Payment (STK)";
    case OrderStatus.paid: return "Paid, Awaiting Dispatch";
    case OrderStatus.outForDelivery: return "Out for Delivery";
    case OrderStatus.delivered: return "Delivered";
    case OrderStatus.cancelled: return "Cancelled";
    case OrderStatus.failed: return "Failed";
  }
}


class OrderModel {
  final String id;
  final List<CartItemModel> items;
  final double totalAmount;
  final DateTime orderDate;
  final String customerName;
  final String customerPhone;
  final String deliveryAddress;
  final PaymentMethod paymentMethod;
  OrderStatus status;
  String? transactionId; // For STK Push

  OrderModel({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    required this.customerName,
    required this.customerPhone,
    required this.deliveryAddress,
    required this.paymentMethod,
    this.status = OrderStatus.pending,
    this.transactionId,
  });
}
// <end of data/models/order_model.dart>