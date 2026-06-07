import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import '../models/contact.dart';

class ContactService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  /// Create a new contact/inquiry
  Future<String> createContact({
    required String buyerId,
    required String farmerId,
    required String listingId,
    required String contactType,
    required String buyerName,
    required String buyerPhone,
    required double quantityInterested,
    String? message,
  }) async {
    try {
      _logger.i(
        'Creating contact: buyer=$buyerId, farmer=$farmerId, type=$contactType',
      );

      final contactRef = _firestore.collection('contacts').doc();

      await contactRef.set({
        'id': contactRef.id,
        'buyerId': buyerId,
        'farmerId': farmerId,
        'listingId': listingId,
        'contactType': contactType,
        'buyerName': buyerName,
        'buyerPhone': buyerPhone,
        'quantityInterested': quantityInterested,
        'message': message,
        'status': 'initiated',
        'createdAt': DateTime.now(),
      });

      // Increment contact count on listing
      await _firestore.collection('produce_listings').doc(listingId).update({
        'contacted': FieldValue.increment(1),
      });

      _logger.i('Contact created successfully: ${contactRef.id}');
      return contactRef.id;
    } catch (e) {
      _logger.e('Error creating contact: $e');
      rethrow;
    }
  }

  /// Get contacts for a farmer
  Future<List<Contact>> getFarmerContacts({
    required String farmerId,
    String? status,
  }) async {
    try {
      _logger.i('Fetching contacts for farmer: $farmerId');

      Query query = _firestore.collection('contacts');
      query = query.where('farmerId', isEqualTo: farmerId);

      if (status != null) {
        query = query.where('status', isEqualTo: status);
      }

      query = query.orderBy('createdAt', descending: true);

      final snapshot = await query.get();

      return snapshot.docs
          .map((doc) => Contact.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _logger.e('Error fetching farmer contacts: $e');
      rethrow;
    }
  }

  /// Get contact details
  Future<Contact?> getContact(String contactId) async {
    try {
      final doc = await _firestore.collection('contacts').doc(contactId).get();

      if (doc.exists) {
        return Contact.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      _logger.e('Error fetching contact: $e');
      rethrow;
    }
  }

  /// Update contact status
  Future<void> updateContactStatus({
    required String contactId,
    required String status,
  }) async {
    try {
      _logger.i('Updating contact status: $contactId to $status');

      final updateData = {'status': status};

      if (status == 'responded') {
        updateData['respondedAt'] = DateTime.now();
      } else if (status == 'completed') {
        updateData['completedAt'] = DateTime.now();
      }

      await _firestore.collection('contacts').doc(contactId).update(updateData);

      _logger.i('Contact status updated successfully');
    } catch (e) {
      _logger.e('Error updating contact status: $e');
      rethrow;
    }
  }

  /// Get contacts initiated by a buyer
  Future<List<Contact>> getBuyerContacts(String buyerId) async {
    try {
      _logger.i('Fetching contacts for buyer: $buyerId');

      final snapshot = await _firestore
          .collection('contacts')
          .where('buyerId', isEqualTo: buyerId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Contact.fromJson(doc.data()))
          .toList();
    } catch (e) {
      _logger.e('Error fetching buyer contacts: $e');
      rethrow;
    }
  }

  /// Get contacts for a specific listing
  Future<List<Contact>> getListingContacts(String listingId) async {
    try {
      _logger.i('Fetching contacts for listing: $listingId');

      final snapshot = await _firestore
          .collection('contacts')
          .where('listingId', isEqualTo: listingId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Contact.fromJson(doc.data()))
          .toList();
    } catch (e) {
      _logger.e('Error fetching listing contacts: $e');
      rethrow;
    }
  }
}
