class ApiEndpointUrls {
  // Auth Endpoint Urls (Lavoauto - Car Washing Service)

  static const String signup_ = "lavoauto_register"; // client signup
  static const String signupWorker_ = "lavoauto_register-lavador"; // washer signup
  static const String uploadProfile = "upload-photo";
  static const String login_ = "lavoauto_login";
  static const String resetPassword_ = "remember-password";
  static const String deleteAccount = "delete-account";

  // Location Api Endpoints
  static const String zipCode_ = "zip?zip=";

  // User Api Endpoints

  static const String userInfo = "lavoauto_user-info?token="; //user / workers
  static const String userCreateOrder = "create-order";
  static const String userGetOrders = "get-order-requests?token=";
  static const String userOrderBids = "list-pujas-for-order?token=";
  static const String userAcceptBid = "accept-puja";
  static const String updateUserInfo = "update-info";

  // Workers Api Endpoints
  static const String workerGetAvailableOrders = "list-available-orders?token=";
  static const String workerMyWork = "my-work";
  static const String workerGetOrderDetails =
      "get-lavador-order-details?token=";
  static const String workerGetAvailableOrderDetails =
      "get-available-order-details?token=";
  static const String workerCreateBid = "create-puja-lavador";
  static const String workerCollect = "lavador-collect-lavado";
  static const String workerDeliverOrder = "deliver-lavado";
  static const String updateWorkerInfo = "update-info-lavador";

  // Rating Api Endpoints
  static const String rateService = "rate-service";
  static const String rateClient = "rate-client";

  // Payment Api Endpoints (Lavoauto-specific - uses LAVOAUTO_STRIPE keys)
  static const String createSetupIntent = "lavoauto_create-setup-intent";
  static const String createPaymentMethod = "lavoauto_create-payment-method"; // Not used currently
  static const String getPaymentMethods = "lavoauto_get-stripe-payment-methods";
  static const String setDefaultPaymentMethod = "lavoauto_set-default-payment-method";
  static const String deletePaymentMethod = "lavoauto_delete-payment-method";
  static const String processAutomaticPayment = "lavoauto_process-automatic-payment"; // Future use

  // App Configuration Api Endpoints
  static const String supportInfo = "support-info";

  // User Addresses Api Endpoints
  static const String getUserAddresses = "get-user-addresses"; // GET
  static const String saveUserAddress = "save-user-address"; // POST
  static const String deleteUserAddress = "delete-user-address"; // DELETE
  static const String setDefaultAddress = "set-default-address"; // POST

  // Order Creation Api Endpoints
  static const String createOrder = "create-order"; // POST

  // Service Management Api Endpoints (Lavador)
  static const String lavoauto_tipos_servicio_catalogo = "lavoauto_tipos-servicio-catalogo"; // GET
  static const String lavoauto_lavador_servicios = "lavoauto_lavador-servicios"; // GET
  static const String lavoauto_add_servicio = "lavoauto_add-servicio"; // POST
  static const String lavoauto_delete_servicio = "lavoauto_delete-servicio"; // DELETE
  static const String lavoauto_update_servicio_disponibilidad = "lavoauto_update-servicio-disponibilidad"; // POST

  // Vehicle Management Api Endpoints (Client)
  static const String lavoauto_get_cliente_vehiculos = "lavoauto_get-cliente-vehiculos"; // GET
  static const String lavoauto_get_catalogo_vehiculos = "lavoauto_get-catalogo-vehiculos"; // GET
  static const String lavoauto_add_catalogo_vehiculo = "lavoauto_add-catalogo-vehiculo"; // POST
  static const String lavoauto_add_cliente_vehiculo = "lavoauto_add-cliente-vehiculo"; // POST
  static const String lavoauto_delete_cliente_vehiculo = "lavoauto_delete-cliente-vehiculo"; // DELETE

  // Order Creation Api Endpoints
  static const String lavoauto_lavadores_cercanos = "lavoauto_lavadores-cercanos"; // GET

  // Order Management Api Endpoints - Cliente
  static const String lavoauto_crear_orden = "lavoauto_crear-orden"; // POST
  static const String lavoauto_mis_ordenes = "lavoauto_mis-ordenes"; // GET

  // Order Management Api Endpoints - Lavador
  static const String lavoauto_lavador_ordenes_pendientes = "lavoauto_lavador-ordenes-pendientes"; // GET
  static const String lavoauto_lavador_comenzar_servicio = "lavoauto_lavador-comenzar-servicio"; // POST
  static const String lavoauto_lavador_completar_servicio = "lavoauto_lavador-completar-servicio"; // POST
  static const String lavoauto_lavador_ordenes_activas = "lavoauto_lavador-ordenes-activas"; // GET
  static const String lavoauto_lavador_mis_ordenes = "lavoauto_lavador-mis-ordenes"; // GET

  // Profile Update Api Endpoints
  static const String lavoauto_update_cliente = "lavoauto_update-cliente"; // POST
}
