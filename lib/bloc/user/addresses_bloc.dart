import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../data/models/request/user/save_user_address_request.dart';
import '../../data/models/response/user/user_address_response.dart';
import '../../data/repositories/address_repo.dart';

// Events
abstract class AddressesEvent {}

class FetchAddressesEvent extends AddressesEvent {}

class SaveAddressEvent extends AddressesEvent {
  final SaveUserAddressRequest request;
  SaveAddressEvent(this.request);
}

class DeleteAddressEvent extends AddressesEvent {
  final int addressId;
  final String token;
  DeleteAddressEvent(this.addressId, this.token);
}

class SetDefaultAddressEvent extends AddressesEvent {
  final int addressId;
  final String token;
  SetDefaultAddressEvent(this.addressId, this.token);
}

// States
abstract class AddressesState {}

class AddressesInitial extends AddressesState {}

class AddressesLoading extends AddressesState {}

class AddressesLoaded extends AddressesState {
  final List<UserAddress> addresses;
  AddressesLoaded(this.addresses);
}

class AddressesSaving extends AddressesState {}

class AddressesSaved extends AddressesState {
  final UserAddress address;
  AddressesSaved(this.address);
}

class AddressesDeleting extends AddressesState {}

class AddressesDeleted extends AddressesState {}

class AddressesError extends AddressesState {
  final String message;
  AddressesError(this.message);
}

// BLoC
@injectable
class AddressesBloc extends Bloc<AddressesEvent, AddressesState> {
  final AddressRepo _addressRepo;

  AddressesBloc(this._addressRepo) : super(AddressesInitial()) {
    on<FetchAddressesEvent>(_onFetchAddresses);
    on<SaveAddressEvent>(_onSaveAddress);
    on<DeleteAddressEvent>(_onDeleteAddress);
    on<SetDefaultAddressEvent>(_onSetDefaultAddress);
  }

  Future<void> _onFetchAddresses(
    FetchAddressesEvent event,
    Emitter<AddressesState> emit,
  ) async {
    emit(AddressesLoading());

    try {
      final response = await _addressRepo.getUserAddresses();
      if (response.data != null) {
        emit(AddressesLoaded(response.data!.addresses));
      } else {
        emit(AddressesError(
            response.errorMessage ?? 'Failed to fetch addresses'));
      }
    } catch (e) {
      emit(AddressesError('Error fetching addresses: $e'));
    }
  }

  Future<void> _onSaveAddress(
    SaveAddressEvent event,
    Emitter<AddressesState> emit,
  ) async {
    emit(AddressesSaving());

    try {
      final response = await _addressRepo.saveUserAddress(event.request);
      if (response.data != null) {
        emit(AddressesSaved(response.data!.address));
        // Fetch updated list
        add(FetchAddressesEvent());
      } else {
        emit(AddressesError(
            response.errorMessage ?? 'Failed to save address'));
      }
    } catch (e) {
      emit(AddressesError('Error saving address: $e'));
    }
  }

  Future<void> _onDeleteAddress(
    DeleteAddressEvent event,
    Emitter<AddressesState> emit,
  ) async {
    emit(AddressesDeleting());

    try {
      final response =
          await _addressRepo.deleteUserAddress(event.addressId, event.token);
      if (response.data != null) {
        emit(AddressesDeleted());
        // Fetch updated list
        add(FetchAddressesEvent());
      } else {
        emit(AddressesError(
            response.errorMessage ?? 'Failed to delete address'));
      }
    } catch (e) {
      emit(AddressesError('Error deleting address: $e'));
    }
  }

  Future<void> _onSetDefaultAddress(
    SetDefaultAddressEvent event,
    Emitter<AddressesState> emit,
  ) async {
    try {
      final response =
          await _addressRepo.setDefaultAddress(event.addressId, event.token);
      if (response.data != null) {
        // Fetch updated list
        add(FetchAddressesEvent());
      } else {
        emit(AddressesError(
            response.errorMessage ?? 'Failed to set default address'));
      }
    } catch (e) {
      emit(AddressesError('Error setting default address: $e'));
    }
  }
}
