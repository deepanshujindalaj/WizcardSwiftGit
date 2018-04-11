//
//  Constants.swift
//  EZER
//
//  Created by TimerackMac1 on 01/11/17.
//  Copyright © 2017 TimerackMac1. All rights reserved.
//

import Foundation
import CoreLocation
let AppName = "Ezer"
struct CellsIdentifiers {
    static let leftmenu = "leftMenu"
}
struct StoryboardNames {
    static let main = "Main"
    static let OnBoarding = "Onboarding"
    static let driver = "Driver"
}
struct IdentifierName {
    struct Main{
        
        static let forgotPassword = "ForgotPwdController"
        static let changePwd = "ChangePwdController"
        static let termsAndPrivacy = "TermsPrivacyController"
        static let ezerNotActive = "EzerNotActiveController"
        static let startViewController = "StartViewController"
        static let decideViewController = "DecideViewController"
        static let decideNavigation = "DecideNavigation"
        static let changePassword = "ChangePassword"
    }
    
    struct  OnBoarding{
        
        static let pageViewController       =   "PageViewController"
        static let helpViewController       =   "HelpViewController"
        static let firstPageViewController  =   "FirstPageViewController"
        static let secondPageViewController =   "SecondPageViewController"
        static let thirdPageViewController  =   "ThirdPageViewController"
        static let fourthPageViewController =   "FourthPageViewController"
        static let loginPageContentViewController = "LoginPageViewController"
        
        static let loginViewCon = "LoginViewController"
        static let confirmViewController = "ConfirmViewController"
    }
    
    struct Segue{
        static let loginPageAnimationSeque = "pageSeque"
        
        static let driverHome = "DriverHomeController"
        static let driverLeftMenu = "LeftMenuController"
        static let driverLoginSplash = "DriverLoginSplash"
        static let paymentHistory = "PaymentHistory"
        static let scheduledJobs = "ScheduledJobsController"
        static let driverOrderDetail = "DriverOrderDetailController"
        static let reviewOrderViewController = "ReviewOrderViewController"
        static let driverLocationStatus = "DriverLocationController"
        static let billingAddress = "BillingAddressController"
        static let driverRegister = "DriverRegistration"
        static let peronalInformation = "PeronalInformation"
        static let vehicleInformation = "VehicleInformation"
        static let driverInformation = "DriverInformation"
        static let OrderProcessPageView = "OrderProcessPageView"
        static let orderProcessView = "OrderProcessView"
        static let driverPicUpload = "DriverPicUpload"
        static let loadTimerView = "LoadTimer"
        static let cancelViewController = "cancelViewController"
        static let popOverDetail = "PopOverDetailController"
    }
   // static let GooglePlaceApiKey = "AIzaSyA8euTE-8sDCo10EflMl2J8qWYqRgOi3J0"//"AIzaSyDRFm0OMNbGjIqwAhSMDGdgfGmjoeuApoE"
    //static let GooglePlaceDirectionKey = "AIzaSyA8euTE-8sDCo10EflMl2J8qWYqRgOi3J0"
    //static let GooglePlaceApiKey = "AIzaSyDRFm0OMNbGjIqwAhSMDGdgfGmjoeuApoE"
    static let GooglePlaceApiKey = "AIzaSyDZr1EOauD2erxR87HZqC9xiubsu6AfxUw"
    static let ReverseURL = "com.ezerapp.payments"
    static var driverCurrentLocation: CLLocationCoordinate2D!
    static let cancelOrderTimeout = 40
    static let descriptionLength = 200
}
enum Roles:String{
    case driver = "driver"
    case client = "client"
}
enum ImageType:String{
    case order = "order"
    case user = "user"
}
enum TruckTypes : String
{
    case small = "SMALL"
    case medium = "MEDIUM"
    case large = "LARGE"
}


struct ServerUrls {
    //
    
    //Mumbai Server Test Instance
//    #define SERVER_URL                              @"http://test.wizcard.be:8080/"
    
    
    //#define SERVER_URL                              @"http://ec2-35-154-226-141.ap-south-1.compute.amazonaws.com:8000"
    //#define SERVER_URL                              @"http://ec2-52-66-189-225.ap-south-1.compute.amazonaws.com:8888"
    //Mumbai Server Released Instance
    //#define SERVER_URL = "https://be.getwizcard.com:443";
    
    
    static let baseAddress = "http://test.wizcard.be:8080/"
    //static let baseAddress = "http://52.8.137.166/ezer-api/"
    
    static let customerSupportEmail = "support@getezer.com"
    static let driverSupportEmail = "drivers@getezer.com"
    struct Main{
        //static let checkActiveArea = "\(baseAddress)client/checkActiveAreaTest"
        static let checkActiveArea = "\(baseAddress)client/checkActiveArea" // replace it for production
        static let insertInterestedUser = "\(baseAddress)client/insertInterestedUser"
        //static let uploadImage = "\(baseAddress)client/imageUpload"
        static let uploadImageToS3 = "\(baseAddress)client/imageUploadOnS3"
        static let deleteImageFromS3 = "\(baseAddress)client/deleteImageFromS3"
        //static let deleteImage = "\(baseAddress)client/deleteImage"
        static let assignTwilioNumber = "\(baseAddress)/assignTwilioNumber"
    }
    
    struct APICalls {
        
        static let kKeyForPhone_Check_Request       =   "phone_check_req"
        static let kKeyForPhone_Check_Response      =   "phone_check_rsp"
        static let kKeyForLogin                     =   "login"
        static let kKeyForRegister                  =   "register"
        
        static let register = "\(baseAddress)client/register"
        static let loginUser = "\(baseAddress)client/login"
        static let ezerQsnAsn = "\(baseAddress)client/getEzerQA"
        static let updateCustomerDetail = "\(baseAddress)client/updateCustomerProfile"
        static let updateCustomerPWD = "\(baseAddress)client/updateCustomerPassword"
        static let updateBillingDetails = "\(baseAddress)client/updateBillingDetails"
        static let getBillingDetails = "\(baseAddress)client/getBillingDetails"
        static let getCustomerDetails = "\(baseAddress)client/getCustomerDetail"
        static let forgotPassword = "\(baseAddress)client/forgotPassword"
        static let orderList = "\(baseAddress)client/getOrdersList"
        static let orderDetails = "\(baseAddress)client/orderDetail"
        static let addUserRatingToDriver = "\(baseAddress)client/addUserRatingToDriver"
        static let addUserTipToDriver = "\(baseAddress)client/addUserRatingAndTipToDriver"
        static let getTotalDistanceAndTime = "\(baseAddress)client/getTotalDistanceAndTime"
        static let getCost = "\(baseAddress)client/getCost"
        static let submitOrder = "\(baseAddress)client/submitOrder"
        static let logout = "\(baseAddress)client/logout"
        static let applycoupon = "\(baseAddress)client/applyCoupon"
        static let cancelOrder = "\(baseAddress)client/cancelOrder"
        static let notifyNearestDriver = "\(baseAddress)client/getNearestDriverLocation"
        static let getPaymentMethods = "\(baseAddress)client/getPaymentMethods"
        static let savePaymentMethod = "\(baseAddress)client/savePaymentMethod"
        static let deletePaymentMethod = "\(baseAddress)client/deletePaymentMethod"
        static let updatePaymentMethod = "\(baseAddress)client/updatePaymentMethod"
        static let createAuthorizationToken = "\(baseAddress)client/createAuthorizationToken"
        static let updateDeviceToken = "\(baseAddress)client/updateDeviceToken"
        static let getCurrentOrderDetail = "\(baseAddress)client/getCurrentOrderDetail"
        static let getDriverLocationDetail = "\(baseAddress)client/getDriverLocation"
        static let changePassword = "\(baseAddress)client/changePassword"
    }
    
    struct Driver{
        static let login = "\(baseAddress)driver/login"
        static let register = "\(baseAddress)driver/register"
        static let forgotPassword = "\(baseAddress)driver/forgotPassword"
        static let getDriverDetails = "\(baseAddress)driver/getDriverDetail"
        static let addPersonalInfo = "\(baseAddress)driver/addDriverPersonalInfo"
        static let addVehicleInfo = "\(baseAddress)driver/addVehicleDetail"
        static let updateDriverDetail = "\(baseAddress)driver/updateDriverProfile"
        static let logout = "\(baseAddress)driver/logout"
       // static let updateDriverAvailabilityStatus = "\(baseAddress)driver/updateDriverAvailabilityStatusTest"
        static let updateDriverAvailabilityStatus = "\(baseAddress)driver/updateDriverAvailabilityStatus"
        static let getDriverAccountDetail = "\(baseAddress)driver/getDriverAccountDetail"
        static let getScheduledJob = "\(baseAddress)driver/getScheduledJob"
        static let getJobHistory = "\(baseAddress)driver/jobHistory"
        static let driverOrderStart = "\(baseAddress)driver/driverOrderStart"
        static let getOrderForDriver = "\(baseAddress)driver/getOrderForDriver"
        //static let updateWorkOrderStatus = "\(baseAddress)driver/updateWorkOrderStatus"
        static let updateWorkOrderStatus = "\(baseAddress)driver/updateWorkOrderStatus"
        static let cancelOrder = "\(baseAddress)driver/cancelOrder"
        static let getDriverPaymentsHistory = "\(baseAddress)driver/getDriverPaymentsHistory"
        static let finishOrder = "\(baseAddress)driver/finishOrder"
        static let addDriverRatingToUser = "\(baseAddress)driver/addDriverRatingToUser"
        static let getOrderDetail = "\(baseAddress)driver/getOrderDetail"
        static let orderTimeout = "\(baseAddress)driver/updateOrderStatusTimeOut"
        static let updateDeviceToken = "\(baseAddress)driver/updateDeviceToken"
        static let getOnDemandOrder = "\(baseAddress)driver/getOnDemandOrder"
        static let getCurrentOrderForDriver = "\(baseAddress)driver/getCurrentOrderForDriver"
        static let changePassword = "\(baseAddress)driver/changePassword"
        static let updateDriverLocation = "\(baseAddress)driver/updateDriverLocation"
    }
    static let termsAndPrivacyUrl = "http://getezer.com/terms.html#terms"
    
}

struct UserDefaultKeys{
    static let kKeyForIsHelpShown = "isHelpShown"
}

struct ServerKeys {
    static let result = "result"
    static let error = "Error"
    
    static let status = "status"
    static let message = "message"
    static let data = "data"
    
    
    static let orderId = "orderId"
    static let pickUpAddress = "startAddress"
    static let dropOffAddress = "destinationAddress"
    static let orderNumber = "orderNumber"
    static let pickupDate = "pickupDate"
    static let pickupTime = "pickupTime"
    static let orderDate = "orderDate"
}

struct ServerStatusCode
{
    static let Success = 1
    static let Failure = 0
}

struct ProfileKeys{
    static let isBusinessUser = "isBusinessUser"
    static let Id = "_id"
    static let profilePic = "profilePic"
    

    static let installationId = "installationId"
    static let isEnabled = "isEnabled"
    static let BTCustomerId = "BTCustomerId"
    
    static let profileType = "profileType"
    
    
    static let deviceToken              =   "pushToken"
    static let password                 =   "password"
    static let deviceID                 =   "deviceID"
    static let user_id                  =   "user_id"
    static let wizuser_id               =   "wizuser_id"
    static let wizcard_id               =   "wizcard_id"
    static let wizcard                  =   "wizcard"
    
    static let last_name                =   "last_name"
    static let first_name               =   "first_name"
    static let phone                    =   "phone"
    static let email                    =   "email"
    static let isExistInRolodex         =   "isExistInRolodex"
    static let contact_container        =   "contact_container"
    
}

struct DriverProfileKeys{
    static let id = "_driverId"
    static let profilePic = "_driverProfilePic"
    static let lastName = "driverLastName"
    static let firstName = "driverFirstName"
    static let cellPhone = "driverCellPhone"
    static let personalInfoVerified = "personalInfoVerified"
    static let vehicleInfoVerified = "vehicleInfoVerified"
    static let isPersonalInfoSubmitted = "isPersonalInfoSubmitted"
    static let isVehicleInfoSubmitted = "isVehicleInfoSubmitted"
    static let availibiltyStatus = "availibiltyStatus"
}

struct FontNames {
    static let light = "Roboto-Light"
    static let regular = "Roboto-Regular"
    static let medium = "Roboto-Medium"
}
enum OrderScheduleTypes : Int
{
    case now = 0
    case later
}
public enum LoginType : String
{
    case driver = "DRIVER"
    case customer = "CUSTOMER"
}

struct CurrentCustomerOrder
{
    static var orderScheduleType : OrderScheduleTypes = .now
}
// Order Status List
enum OrderStatusType : String
{
    /*case open = "OPEN"
    case driverReview = "DRIVER_REVIEW"
    case accepted = "ACCEPTED"
    case onTheWay = "ON_THE_WAY"
    case atSource = "AT_SOURCE"
    case loaded = "LOADED"
    case inTransit = "IN_TRANSIT"
    case multi_pickup_transit = "MULTI_ORDER_PICKUP_IN_TRANSIST"
    case multi_drop_transit = "MULTI_ORDER_DROP_IN_TRANSIST"
    case atDestination = "AT_DESTINATION"
    case unloaded = "UNLOADED"
    case finished = "FINISHED"
    case done = "DONE"
    case cancelled = "CANCELLED"
    case timeout = "TIMEOUT"*/
    //case available = "AVAILABLE"
    //case UNAvailable = "UNAVAILABLE"
    case open = "OPEN"
    case driverReview = "DRIVER_REVIEW"
    case accepted = "ACCEPTED"
    case onTheWay = "ON_THE_WAY"
    case atSource = "AT_SOURCE" // on customer Location
    case startLoading = "START_LOADING" // on customer Location
    case loadTimer = "LOAD_TIMER" // custom
    case loaded = "LOADED" // After Loading pics
    case inTransit = "IN_TRANSIT"
    case multi_pickup_transit = "MULTI_ORDER_PICKUP_IN_TRANSIT"
    case multi_drop_transit = "MULTI_ORDER_DROP_IN_TRANSIT"
    case atDestination = "AT_DESTINATION"
    case beforeUnload = "BEFORE_UNLOAD" // custom
    case unloadTimer = "UNLOAD_TIMER" // custom
    case unloaded = "UNLOADED"
    case finished = "FINISHED"
    case done = "DONE"
    case cancelled = "CANCELLED"
    case timeout = "TIMEOUT"
    
}
enum DriverStatusTypes:String{
    case available = "AVAILABLE"
    case unavailable = "UNAVAILABLE"
    case busy = "BUSY"
}

enum DriverUIStatus:String{
    case on = "ON"
    case off = "OFF"
    case accept = "ACCEPT"
}

struct ValidationMessages {
    static let invalidPhone =   "Please Input Valid Phone Number"
    static let invalidCode  =   "Please Input Valid Code"
    

    static let disabledUser = "You are disabled by admin"
    static let noInternet = "You are not connected to internet"
    static let serverFailiure = "Server Faliure"
    static let gettingLocation = "Gettting Location"
    static let checkingArea = "Checking Area"
    static let thanksUser = "Thanks for feedback"
    static let ezerNotActive = "Ezer Not Active in your area"
    static let statusBusy = "You can't disable while on Ride"
    static let somethingWentWrong = "Something went wrong"
    static let selectHearEzerChoice = "Please select value"
    static let passwordNotMatch = "Password do not match"
    static let passwordLenghthError = "Password must be of minimum 6 characters"
    static let startLocationError = "Please set valid start location"
    static let endLocationError = "Please set valid destination location"
    static let profilePicError = "Please upload profile picture"
    static let invalidEmail = "Invalid email"
    static let validWeight = "Please enter valid Weight"
    static let invalidZipCode = "Invalid zipcode"
    static let promocodeFieldError = "Please enter valid promocode"
    static let promocodeSuccess = "Promo code applied"
    static let dateException = "Order can not be scheduled in past date"
    static let cancelOrder = "Do you want to cancel the order?"
    static let placeOrder = "Do you want to place an order NOW?"
    static let orderPlaced = "Order has been placed successfully"
    static let placeOrderLater = "Do you want to set the order for %@ %@ at %@ %@ ?"
    static let deletePayment = "Do you want to delete the payment method?"
    static let makeDefaultPayment = "Do you want to make this as your default payment method"
    static let photoOfInsurance = "Photo of Insurance is required"
    static let photoOfRegistration = "Photo of Registration is required"
    static let photoOfVehicleFrontRequired  = "Photo of Vehicle Front is required"
    static let photoOfVehicleRightRequired  = "Photo of Vehicle Right-Side is required"
    static let photoOfVehicleLeftRequired  = "Photo of Vehicle Left-Side is required"
    static let photoOfVehicleBackRequired  = "Photo of Vehicle Back is required"
    static let sameLocationError    =   "Start and destination location must be different"
    static let invalidReason        =   "Please enter a valid reason"
    static let driverLocationAlert = "Please go to Settings > EZER >\nLocation and set to \"Always\""
    static let changeAvailableStatus = "Please change your status to Available before starting"
    static let uploadImageError = "Please upload an image"
    static let orderCancelByUser = "Order has been cancelled by user"
    static let orderCancelByDriver = "Your order has been cancelled by driver\n We will notify you when new driver assigned"
    static let noDriverAssigned = "No Driver Assigned"
    static let descriptionEmpty = "Please enter description"
    static let finishPreviousOrder = "Please finish previous order first"
    static let timeIsDelayed = "You can't go for job before 2 hours!"
    static let OrderDatePasted  =   "Order date is passed, you can't go there right now"
    static let OrderCancelRejected = "Order can not be Cancel now!"
    static let errorInBtCusomterId = "Error while creating new customer"
    static let EstimatedCostNote = "Note:- Estimated price is based on a per mile and time calculation with a minimum rate of $28.00. Time includes the transit time as well as loading and unloading time. Final price may fluctuate depending on delays due to traffic condition, bad weather or road construction. This estimate also does not include any required toll costs. If at any time you have questions, please contact us directly at \"Questions@GetEZER.com\"."
}

let vehicleTypes:[String] = [
    "Small Size Pickup",
    "Full Size Pickup",
    "Cargo Van",
    "SUV",
    "Mini Van",
    "Stake Bed",
]

let statesList = [
    (name: "Alabama",code: "AL"),
    (name: "Alaska",code: "AK"),
    (name: "American Samoa",code: "AS"),
    (name: "Arizona",code: "AZ"),
    (name: "Arkansas",code: "AR"),
    (name: "California",code: "CA"),
    (name: "Colorado",code: "CO"),
    (name: "Connecticut",code: "CT"),
    (name: "Delaware",code: "DE"),
    (name: "District Of Columbia",code: "DC"),
    (name: "Federated States Of Micronesia",code: "FM"),
    (name: "Florida",code: "FL"),
    (name: "Georgia",code: "GA"),
    (name: "Guam",code: "GU"),
    (name: "Hawaii",code: "HI"),
    (name: "Idaho",code: "ID"),
    (name: "Illinois", code: "IL"),
    (name: "Indiana",code: "IN"),
    (name: "Iowa",code: "IA"),
    (name: "Kansas",code: "KS"),
    (name: "Kentucky",code: "KY"),
    (name: "Louisiana",code: "LA"),
    (name: "Maine",code: "ME"),
    (name: "Marshall Islands",code: "MH"),
    (name: "Maryland",code: "MD"),
    (name: "Massachusetts",code: "MA"),
    (name: "Michigan",code: "MI"),
    (name: "Minnesota",code: "MN"),
    (name: "Mississippi",code: "MS"),
    (name: "Missouri",code: "MO"),
    (name: "Montana",code: "MT"),
    (name: "Nebraska",code: "NE"),
    (name: "Nevada",code: "NV"),
    (name: "New Hampshire",code: "NH"),
    (name: "New Jersey",code: "NJ"),
    (name: "New Mexico",code: "NM"),
    (name: "New York",code: "NY"),
    (name: "North Carolina",code: "NC"),
    (name: "North Dakota",code: "ND"),
    (name: "Northern Mariana Islands",code: "MP"),
    (name: "Ohio",code: "OH"),
    (name: "Oklahoma",code: "OK"),
    (name: "Oregon",code: "OR"),
    (name: "Palau",code: "PW"),
    (name: "Pennsylvania",code: "PA"),
    (name: "Puerto Rico",code: "PR"),
    (name: "Rhode Island",code: "RI"),
    (name: "South Carolina",code: "SC"),
    (name: "South Dakota",code: "SD"),
    (name: "Tennessee",code: "TN"),
    (name: "Texas",code: "TX"),
    (name: "Utah",code: "UT"),
    (name: "Vermont",code: "VT"),
    (name: "Virgin Islands",code: "VI"),
    (name: "Virginia",code: "VA"),
    (name: "Washington",code: "WA"),
    (name: "West Virginia",code: "WV"),
    (name: "Wisconsin",code: "WI"),
    (name: "Wyoming",code: "WY")
]
