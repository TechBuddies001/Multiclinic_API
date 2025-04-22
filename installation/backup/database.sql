-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Apr 19, 2025 at 08:32 AM
-- Server version: 10.11.10-MariaDB-log
-- PHP Version: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `u806435594_medicaretest`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin_notification`
--

CREATE TABLE `admin_notification` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `clinic_id` bigint(20) UNSIGNED DEFAULT NULL,
  `appointment_id` bigint(20) UNSIGNED DEFAULT NULL,
  `txn_id` bigint(20) UNSIGNED DEFAULT NULL,
  `title` varchar(250) NOT NULL,
  `body` varchar(250) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `all_transaction`
--

CREATE TABLE `all_transaction` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `clinic_id` bigint(20) UNSIGNED DEFAULT NULL,
  `patient_id` bigint(20) UNSIGNED DEFAULT NULL,
  `appointment_id` bigint(20) UNSIGNED DEFAULT NULL,
  `payment_transaction_id` text DEFAULT NULL,
  `amount` double NOT NULL,
  `transaction_type` enum('Credited','Debited') NOT NULL,
  `is_wallet_txn` tinyint(1) NOT NULL DEFAULT 0,
  `last_wallet_amount` double DEFAULT NULL,
  `new_wallet_amount` double DEFAULT NULL,
  `notes` varchar(250) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `appointments`
--

CREATE TABLE `appointments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `patient_id` bigint(20) UNSIGNED NOT NULL,
  `status` enum('Pending','Confirmed','Rejected','Completed','Rescheduled','Cancelled','Visited') NOT NULL,
  `date` date NOT NULL,
  `time_slots` time NOT NULL,
  `doct_id` bigint(20) UNSIGNED NOT NULL,
  `clinic_id` bigint(20) UNSIGNED NOT NULL,
  `dept_id` bigint(20) UNSIGNED NOT NULL,
  `type` enum('OPD','Video Consultant','Emergency') NOT NULL,
  `meeting_id` text DEFAULT NULL,
  `meeting_link` text DEFAULT NULL,
  `payment_status` enum('Paid','Unpaid','Partially Paid','Refunded') DEFAULT NULL,
  `current_cancel_req_status` enum('Initiated','Rejected','Approved','Processing') DEFAULT NULL,
  `source` enum('Android App','Ios App','Web','Admin','Front Desk','Doctor') DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `appointments_invoice_item`
--

CREATE TABLE `appointments_invoice_item` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `invoice_id` bigint(20) UNSIGNED NOT NULL,
  `clinic_id` bigint(20) UNSIGNED DEFAULT NULL,
  `description` varchar(250) NOT NULL,
  `quantity` int(11) NOT NULL,
  `unit_price` double NOT NULL,
  `unit_tax` double DEFAULT NULL,
  `unit_tax_amount` double DEFAULT NULL,
  `service_charge` double DEFAULT 0,
  `total_price` double NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `appointment_cancellation_req`
--

CREATE TABLE `appointment_cancellation_req` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `appointment_id` bigint(20) UNSIGNED NOT NULL,
  `status` enum('Initiated','Rejected','Approved','Processing') NOT NULL,
  `notes` varchar(250) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `appointment_checkin`
--

CREATE TABLE `appointment_checkin` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `appointment_id` bigint(20) UNSIGNED NOT NULL,
  `clinic_id` bigint(20) UNSIGNED NOT NULL,
  `time` time NOT NULL,
  `date` date NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `appointment_invoice`
--

CREATE TABLE `appointment_invoice` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `clinic_id` bigint(20) UNSIGNED DEFAULT NULL,
  `patient_id` bigint(20) UNSIGNED DEFAULT NULL,
  `appointment_id` bigint(20) UNSIGNED DEFAULT NULL,
  `status` enum('Unpaid','Paid','Partially Paid','Cancelled') NOT NULL,
  `coupon_title` varchar(250) DEFAULT NULL,
  `coupon_value` double DEFAULT NULL,
  `coupon_off_amount` double DEFAULT NULL,
  `coupon_id` bigint(20) UNSIGNED DEFAULT NULL,
  `total_amount` double NOT NULL,
  `invoice_date` date NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `appointment_payments`
--

CREATE TABLE `appointment_payments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `txn_id` bigint(20) UNSIGNED NOT NULL,
  `invoice_id` bigint(20) UNSIGNED DEFAULT NULL,
  `clinic_id` bigint(20) UNSIGNED DEFAULT NULL,
  `amount` double NOT NULL,
  `payment_time_stamp` timestamp NULL DEFAULT NULL,
  `payment_method` enum('Cash','Online','Other','Wallet','UPI') DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `appointment_status_log`
--

CREATE TABLE `appointment_status_log` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `patient_id` bigint(20) UNSIGNED NOT NULL,
  `appointment_id` bigint(20) UNSIGNED NOT NULL,
  `clinic_id` bigint(20) UNSIGNED NOT NULL,
  `status` varchar(250) NOT NULL,
  `notes` varchar(250) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `banners`
--

CREATE TABLE `banners` (
  `id` bigint(11) UNSIGNED NOT NULL,
  `preferences` int(11) NOT NULL DEFAULT 0,
  `image` text NOT NULL,
  `type` enum('Mobile','Web') NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cities`
--

CREATE TABLE `cities` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `state_id` bigint(20) UNSIGNED NOT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 0,
  `default_city` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `clinics`
--

CREATE TABLE `clinics` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `city_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `address` varchar(250) DEFAULT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `active` tinyint(1) DEFAULT 0,
  `description` text DEFAULT NULL,
  `image` text DEFAULT NULL,
  `email` varchar(250) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `phone_second` varchar(50) DEFAULT NULL,
  `ambulance_btn_enable` tinyint(1) NOT NULL DEFAULT 0,
  `ambulance_number` varchar(50) DEFAULT NULL,
  `stop_booking` tinyint(1) NOT NULL DEFAULT 0,
  `coupon_enable` tinyint(1) NOT NULL DEFAULT 0,
  `tax` double NOT NULL DEFAULT 0,
  `opening_hours` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`opening_hours`)),
  `whatsapp` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `clinic_images`
--

CREATE TABLE `clinic_images` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `clinic_id` bigint(20) UNSIGNED NOT NULL,
  `image` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `configurations`
--

CREATE TABLE `configurations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_name` varchar(250) NOT NULL,
  `group_name` enum('Video','Basic','Mobile App','Ambulance','Appointment','Firebase','Payment','Web','Map') NOT NULL,
  `preferences` int(11) NOT NULL,
  `title` varchar(250) NOT NULL,
  `value` text DEFAULT NULL,
  `description` varchar(250) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `configurations`
--

INSERT INTO `configurations` (`id`, `id_name`, `group_name`, `preferences`, `title`, `value`, `description`, `created_at`, `updated_at`) VALUES
(1, 'zoom_client_id', 'Video', 1, 'Zoom Client Id', 'xxxxxxxxxxx', '', '2024-08-09 16:59:45', '2024-12-26 08:18:42'),
(2, 'zoom_client_secret', 'Video', 2, 'Zoom Client Secret', 'xxxxxxxxxxx', '', '2024-08-09 16:59:45', '2024-12-26 08:18:49'),
(3, 'zoom_account_id', 'Video', 2, 'Zoom Account Id', 'xxxxxxxxxxx', '', '2024-08-09 16:59:45', '2024-12-26 08:18:55'),
(4, 'logo', 'Basic', 1, 'Logo', 'configurations/2024-10-24-671a440c85bb9', '', '2024-08-09 16:59:45', '2025-03-28 16:08:00'),
(5, 'fav_icon', 'Basic', 2, 'Fav Icon', NULL, '', '2024-08-09 16:59:45', '2025-03-09 03:02:15'),
(6, 'clinic_name', 'Basic', 4, 'Clinic', 'Medicare', '', '2024-08-09 16:59:45', '2025-04-18 06:41:40'),
(7, 'email', 'Basic', 5, 'Email', 'example@gmail.com', '', '2024-08-09 16:59:45', '2024-10-24 12:54:00'),
(8, 'phone', 'Basic', 6, 'Phone', '+911234567811', '', '2024-08-09 16:59:45', '2024-12-18 09:37:50'),
(9, 'phone_second', 'Basic', 7, 'Phone Second', '+911234567892', '', '2024-08-09 16:59:45', '2024-09-02 04:14:38'),
(10, 'address', 'Basic', 8, 'Address', 'Address', '', '2024-08-09 16:59:45', '2024-09-03 06:41:19'),
(11, 'play_store_link', 'Mobile App', 8, 'Play Store Link', 'https://android', '', '2024-08-09 16:59:45', '2024-09-02 04:14:38'),
(12, 'app_store_link', 'Mobile App', 8, 'App Store Link', 'https://ios', '', '2024-08-09 16:59:45', '2024-09-02 04:14:38'),
(13, 'android_android_app_version', 'Mobile App', 8, 'Android App Version', '2.0.0', '', '2024-08-09 16:59:45', '2024-11-23 19:24:49'),
(14, 'android_update_box_enable', 'Mobile App', 8, 'Android Update Box Enable', 'false', '', '2024-08-09 16:59:45', '2024-10-24 12:57:14'),
(15, 'android_force_update_box_enable', 'Mobile App', 8, 'Android Force Update Box Enable', 'false', '', '2024-08-09 16:59:45', '2024-09-03 05:53:27'),
(16, 'android_technical_issue_enable', 'Mobile App', 8, 'Technical Issue Enable', 'false', '', '2024-08-09 16:59:45', '2024-09-26 06:07:54'),
(17, 'ios_app_version', 'Mobile App', 8, 'Ios App Version', '2.0.0', '', '2024-08-09 16:59:45', '2024-11-23 19:25:26'),
(18, 'ios_update_box_enable', 'Mobile App', 8, 'Ios Update Box Enable', 'false', '', '2024-08-09 16:59:45', '2024-09-02 13:38:09'),
(19, 'ios_force_update_box_enable', 'Mobile App', 8, 'Ios Force Update Box Enable', 'false', '', '2024-08-09 16:59:45', '2024-09-02 13:38:08'),
(20, 'ios_technical_issue_enable', 'Mobile App', 8, 'Ios Technical Issue Enable', 'false', '', '2024-08-09 16:59:45', '2024-09-02 13:38:07'),
(23, 'stop_booking', 'Appointment', 8, 'Stop Booking', 'false', '', '2024-08-09 16:59:45', '2025-04-11 06:57:59'),
(24, 'c_u_p_d_p_a', 'Mobile App', 4, 'Contact Us Page Description Patient App', 'You can contact us through Email: contactus@gmail.com we will reply in 2-3 working days.', '', '2024-08-09 16:59:45', '2024-09-03 06:07:23'),
(25, 's_p_d_p_a', 'Mobile App', 5, 'Share Page Description Patient App', 'Tell your friend to use this app by clicking the share button.', '', '2024-08-09 16:59:45', '2024-09-02 04:14:38'),
(26, 'play_store_link_doctor_app', 'Mobile App', 8, 'Play Store Link Doctor App', 'https://android', '', '2024-08-09 16:59:45', '2024-09-02 04:14:38'),
(27, 'app_store_link_doctor_app', 'Mobile App', 8, 'App Store Link Doctor App', 'https://ios', '', '2024-08-09 16:59:45', '2024-09-02 04:14:38'),
(28, 'c_u_p_d_d_a', 'Mobile App', 4, 'Contact Us Page Description Doctor App', 'You can contact us through Email: contactus@gmail.com we will reply in 2-3 working days.', '', '2024-08-09 16:59:45', '2024-09-03 06:07:23'),
(29, 's_p_d_d_a', 'Mobile App', 5, 'Share Page Description Dcotor App', 'Tell your friend to use this app by clicking the share button.', '', '2024-08-09 16:59:45', '2024-09-02 04:14:38'),
(30, 'google_service_account_json', 'Firebase', 5, 'GOOGLE_SERVICE_ACCOUNT_JSON', '', '', '2024-08-09 16:59:45', '2024-11-29 07:45:44'),
(34, 'web_technical_issue_enable', 'Web', 10, 'Web Technical Issue Enable', 'false', '', '2024-09-26 19:53:04', '2024-12-31 12:06:02'),
(35, 'web_doctor_image', 'Web', 5, 'Doctor Image', 'configurations/2024-11-05-6729c267086c7.png', '300hX200w', '2024-08-09 16:59:45', '2025-03-15 12:05:10'),
(38, 'whatsapp', 'Basic', 6, 'Whatsapp', '+911234567890', '', '2024-08-09 16:59:45', '2024-12-19 08:13:15'),
(40, 'google_map_api_key', 'Mobile App', 5, 'Google Map Api Key', '', '', '2024-08-09 16:59:45', '2025-03-31 09:21:28');

-- --------------------------------------------------------

--
-- Table structure for table `contact_form_inbox`
--

CREATE TABLE `contact_form_inbox` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(250) NOT NULL,
  `email` varchar(250) NOT NULL,
  `message` text NOT NULL,
  `subject` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `country`
--

CREATE TABLE `country` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(250) NOT NULL,
  `iso_code` varchar(250) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `coupon`
--

CREATE TABLE `coupon` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `clinic_id` int(11) NOT NULL,
  `title` varchar(250) NOT NULL,
  `description` varchar(250) NOT NULL,
  `value` double NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `active` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `coupon_use`
--

CREATE TABLE `coupon_use` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `coupon_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `clinic_id` bigint(20) UNSIGNED NOT NULL,
  `appointment_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `department`
--

CREATE TABLE `department` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(250) NOT NULL,
  `description` text DEFAULT NULL,
  `image` text DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `doctors`
--

CREATE TABLE `doctors` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `stop_booking` tinyint(4) NOT NULL DEFAULT 0,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `clinic_id` bigint(20) UNSIGNED DEFAULT NULL,
  `department` bigint(20) UNSIGNED NOT NULL,
  `description` text DEFAULT NULL,
  `specialization` varchar(250) NOT NULL,
  `ex_year` int(11) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 0,
  `video_appointment` tinyint(1) NOT NULL DEFAULT 1,
  `clinic_appointment` tinyint(1) NOT NULL DEFAULT 1,
  `emergency_appointment` tinyint(1) NOT NULL DEFAULT 0,
  `opd_fee` double NOT NULL DEFAULT 200,
  `video_fee` double NOT NULL DEFAULT 200,
  `emg_fee` double NOT NULL DEFAULT 200,
  `zoom_client_id` text DEFAULT NULL,
  `zoom_secret_id` text DEFAULT NULL,
  `insta_link` text DEFAULT NULL,
  `fb_linik` text DEFAULT NULL,
  `twitter_link` text DEFAULT NULL,
  `you_tube_link` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `doctors_review`
--

CREATE TABLE `doctors_review` (
  `id` bigint(20) NOT NULL,
  `doctor_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL COMMENT 'patient_id',
  `appointment_id` bigint(20) UNSIGNED DEFAULT NULL,
  `clinic_id` bigint(20) UNSIGNED DEFAULT NULL,
  `points` int(11) NOT NULL DEFAULT 0,
  `description` varchar(250) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `doctor_notification`
--

CREATE TABLE `doctor_notification` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `appointment_id` bigint(20) UNSIGNED DEFAULT NULL,
  `prescription_id` bigint(20) UNSIGNED DEFAULT NULL,
  `title` varchar(250) NOT NULL,
  `body` varchar(250) NOT NULL,
  `doctor_id` bigint(20) UNSIGNED NOT NULL,
  `file_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `family_members`
--

CREATE TABLE `family_members` (
  `id` bigint(11) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `f_name` varchar(250) NOT NULL,
  `l_name` varchar(250) NOT NULL,
  `isd_code` varchar(6) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `gender` enum('Male','Female','Other') DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `login_screen_image`
--

CREATE TABLE `login_screen_image` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `preferences` int(11) NOT NULL DEFAULT 0,
  `image` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `login_screen_image`
--

INSERT INTO `login_screen_image` (`id`, `preferences`, `image`, `created_at`, `updated_at`) VALUES
(24, 0, 'loginscreen/2025-03-31-67eadf7219997.png', '2025-03-31 18:31:14', '2025-03-31 18:31:14');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_reset_tokens_table', 1),
(3, '2019_08_19_000000_create_failed_jobs_table', 1),
(4, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(5, '2024_01_03_041344_create_permission_tables', 1);

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `patients`
--

CREATE TABLE `patients` (
  `id` bigint(10) UNSIGNED NOT NULL,
  `clinic_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `f_name` varchar(250) NOT NULL,
  `l_name` varchar(250) NOT NULL,
  `isd_code` varchar(6) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `city` varchar(250) DEFAULT NULL,
  `state` varchar(250) DEFAULT NULL,
  `address` varchar(250) DEFAULT NULL,
  `email` varchar(250) DEFAULT NULL,
  `gender` enum('Male','Female','Other','') DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `image` varchar(250) DEFAULT NULL,
  `postal_code` int(11) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `patient_clinic`
--

CREATE TABLE `patient_clinic` (
  `id` int(10) UNSIGNED NOT NULL,
  `patient_id` bigint(20) UNSIGNED NOT NULL,
  `clinic_id` bigint(20) UNSIGNED NOT NULL,
  `referral_requests_id` bigint(20) UNSIGNED DEFAULT NULL,
  `linking_code` bigint(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL,
  `updated_at` timestamp NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `patient_files`
--

CREATE TABLE `patient_files` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `patient_id` bigint(20) UNSIGNED NOT NULL,
  `clinic_id` bigint(20) UNSIGNED DEFAULT NULL,
  `file_name` varchar(250) NOT NULL,
  `file` text DEFAULT NULL,
  `created_at` timestamp NOT NULL,
  `updated_at` timestamp NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payment_gateway`
--

CREATE TABLE `payment_gateway` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` enum('Razorpay','Stripe') NOT NULL,
  `key` text NOT NULL,
  `secret` text NOT NULL,
  `webhook_secret_key` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `payment_gateway`
--

INSERT INTO `payment_gateway` (`id`, `title`, `key`, `secret`, `webhook_secret_key`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Razorpay', 'xxxxxxxxxxxxxxxx', 'xxxxxxxxxxxxxxxxxx', 'xxxxxxxxxxxxxxxxxxxx', 1, '2024-09-18 18:04:51', '2025-03-19 10:14:47'),
(2, 'Stripe', 'xxxxxxxxxxxxxxxx', 'xxxxxxxxxxxxxxxxxxxx', 'xxxxxxxxxxxxxxxx', 0, '2024-09-18 18:04:51', '2025-03-19 10:12:31');

-- --------------------------------------------------------

--
-- Table structure for table `permission`
--

CREATE TABLE `permission` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `group_id` int(11) NOT NULL,
  `name` varchar(250) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `permission`
--

INSERT INTO `permission` (`id`, `group_id`, `name`, `created_at`, `updated_at`) VALUES
(1, 1, 'USER_VIEW', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(2, 1, 'USER_ADD', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(3, 1, 'USER_UPDATE', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(4, 1, 'USER_DELETE', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(5, 2, 'PATIENT_VIEW', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(6, 2, 'PATIENT_ADD', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(7, 2, 'PATIENT_UPDATE', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(8, 2, 'PATIENT_DELETE', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(9, 3, 'DOCTOR_VIEW', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(10, 3, 'DOCTOR_ADD', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(11, 3, 'DOCTOR_UPDATE', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(12, 3, 'DOCTOR_DELETE', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(13, 4, 'DEPARTMENT_VIEW', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(14, 4, 'DEPARTMENT_ADD', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(15, 4, 'DEPARTMENT_UPDATE', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(16, 4, 'DEPARTMENT_DELETE', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(17, 5, 'SPECIALIZATION_VIEW', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(18, 5, 'SPECIALIZATION_ADD', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(19, 5, 'SPECIALIZATION_UPDATE', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(20, 5, 'SPECIALIZATION_DELETE', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(21, 6, 'MEDICINE_VIEW', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(22, 6, 'MEDICINE_ADD', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(23, 6, 'MEDICINE_UPDATE', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(24, 6, 'MEDICINE_DELETE', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(25, 7, 'CITY_VIEW', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(26, 7, 'CITY_ADD', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(27, 7, 'CITY_UPDATE', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(28, 7, 'CITY_DELETE', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(29, 8, 'STATE_VIEW', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(30, 8, 'STATE_ADD', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(31, 8, 'STATE_UPDATE', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(32, 8, 'STATE_DELETE', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(33, 9, 'APPOINTMENT_PAYMENTS_VIEW', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(34, 10, 'APPOINTMENT_INVOICE_VIEW', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(35, 11, 'ALL_TRANSACTION_VIEW', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(36, 11, 'ALL_TRANSACTION_ADD', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(37, 12, 'PRESCRIPTION_VIEW', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(38, 12, 'PRESCRIPTION_ADD', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(39, 12, 'PRESCRIPTION_UPDATE', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(40, 12, 'PRESCRIPTION_DELETE', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(41, 13, 'APPOINTMENT_VIEW', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(42, 13, 'APPOINTMENT_ADD', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(43, 13, 'APPOINTMENT_UPDATE', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(44, 13, 'APPOINTMENT_DELETE', '2024-08-15 17:51:21', '2024-08-15 17:51:21'),
(45, 14, 'SETTING_VIEW', '2024-08-27 00:00:00', '2024-08-27 00:00:00'),
(46, 15, 'FAMILY_VIEW', NULL, NULL),
(48, 15, 'FAMILY_UPDATE', NULL, NULL),
(49, 15, 'FAMILY_ADD', '2024-08-29 00:00:00', '2024-08-29 00:00:00'),
(50, 15, 'FAMILY_DELETE', '2024-08-29 00:00:00', '2024-08-29 00:00:00'),
(55, 16, 'FILE_VIEW', '2024-10-25 16:25:59', '2024-10-25 16:25:59'),
(56, 16, 'FILE_ADD', '2024-10-25 16:25:59', '2024-10-25 16:25:59'),
(57, 16, 'FILE_UPDATE', '2024-10-25 16:25:59', '2024-10-25 16:25:59'),
(58, 16, 'FILE_DELETE', '2024-10-25 16:25:59', '2024-10-25 16:25:59'),
(59, 17, 'LOGINSCREEN_VIEW', '2024-10-25 16:27:03', '2024-10-25 16:27:03'),
(60, 17, 'LOGINSCREEN_ADD', '2024-10-25 16:27:03', '2024-10-25 16:27:03'),
(61, 17, 'LOGINSCREEN_UPDATE', '2024-10-25 16:27:03', '2024-10-25 16:27:03'),
(62, 17, 'LOGINSCREEN_DELETE', '2024-10-25 16:27:03', '2024-10-25 16:27:03'),
(63, 18, 'COUPON_VIEW', '2024-10-25 16:28:50', '2024-10-25 16:28:50'),
(64, 18, 'COUPON_ADD', '2024-10-25 16:28:50', '2024-10-25 16:28:50'),
(65, 18, 'COUPON_UPDATE', '2024-10-25 16:28:50', '2024-10-25 16:28:50'),
(66, 18, 'COUPON_DELETE', '2024-10-25 16:28:50', '2024-10-25 16:28:50'),
(67, 19, 'CHECKIN_VIEW', '2024-12-20 14:12:38', '2024-12-20 14:12:38'),
(68, 19, 'CHECKIN_ADD', '2024-12-20 14:12:38', '2024-12-20 14:12:38'),
(69, 19, 'CHECKIN_UPDATE', '2024-12-20 14:12:38', '2024-12-20 14:12:38'),
(70, 19, 'CHECKIN_DELETE', '2024-12-20 14:12:38', '2024-12-20 14:12:38'),
(75, 20, 'NOTIFICATION_VIEW', '2024-12-20 14:22:04', '2024-12-20 14:22:04'),
(76, 20, 'NOTIFICATION_ADD', '2024-12-20 14:22:04', '2024-12-20 14:22:04'),
(77, 20, 'NOTIFICATION_UPDATE', '2024-12-20 14:22:04', '2024-12-20 14:22:04'),
(78, 20, 'NOTIFICATION_DELETE', '2024-12-20 14:22:04', '2024-12-20 14:22:04'),
(79, 21, 'TESTIMONIAL_VIEW', '2024-12-20 14:24:23', '2024-12-20 14:24:23'),
(80, 21, 'TESTIMONIAL_ADD', '2024-12-20 14:24:23', '2024-12-20 14:24:23'),
(81, 21, 'TESTIMONIAL_UPDATE', '2024-12-20 14:24:23', '2024-12-20 14:24:23'),
(82, 21, 'TESTIMONIAL_DELETE', '2024-12-20 14:24:23', '2024-12-20 14:24:23'),
(83, 22, 'WALLET_VIEW', '2024-12-20 18:07:10', '2024-12-20 18:07:10'),
(84, 22, 'WALLET_ADD', '2024-12-20 18:07:10', '2024-12-20 18:07:10'),
(85, 22, 'WALLET_UPDATE', '2024-12-20 18:07:10', '2024-12-20 18:07:10'),
(86, 22, 'WALLET_DELETE', '2024-12-20 18:07:10', '2024-12-20 18:07:10'),
(87, 23, 'REFER_ADD', '2025-03-15 12:22:03', '2025-03-15 12:22:03'),
(88, 23, 'REFER_UPDATE', '2025-03-15 12:22:03', '2025-03-15 12:22:03'),
(89, 23, 'REFER_VIEW', '2025-03-15 12:22:03', '2025-03-15 12:22:03'),
(90, 23, 'REFER_DELETE', '2025-03-15 12:22:03', '2025-03-15 12:22:03'),
(95, 23, 'MANAGE_PERMISSIONS', '2025-04-11 19:20:13', '2025-04-11 19:20:13');

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `prescribe_medicines`
--

CREATE TABLE `prescribe_medicines` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `clinic_id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(250) NOT NULL,
  `notes` varchar(250) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `prescription`
--

CREATE TABLE `prescription` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `appointment_id` bigint(20) UNSIGNED NOT NULL,
  `clinic_id` bigint(20) UNSIGNED NOT NULL,
  `patient_id` bigint(20) UNSIGNED NOT NULL,
  `date` date NOT NULL,
  `test` text DEFAULT NULL,
  `advice` text DEFAULT NULL,
  `problem_desc` text DEFAULT NULL,
  `food_allergies` varchar(250) DEFAULT NULL,
  `tendency_bleed` varchar(250) DEFAULT NULL,
  `heart_disease` varchar(250) DEFAULT NULL,
  `blood_pressure` varchar(250) DEFAULT NULL,
  `diabetic` varchar(250) DEFAULT NULL,
  `surgery` varchar(250) DEFAULT NULL,
  `accident` varchar(250) DEFAULT NULL,
  `others` varchar(250) DEFAULT NULL,
  `medical_history` varchar(250) DEFAULT NULL,
  `current_medication` varchar(250) DEFAULT NULL,
  `female_pregnancy` varchar(250) DEFAULT NULL,
  `breast_feeding` varchar(250) DEFAULT NULL,
  `pulse_rate` varchar(250) DEFAULT NULL,
  `temperature` varchar(250) DEFAULT NULL,
  `next_visit` varchar(250) DEFAULT NULL,
  `pdf_file` text DEFAULT NULL,
  `json_data` longtext DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `prescription_item`
--

CREATE TABLE `prescription_item` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `prescription_id` bigint(20) UNSIGNED NOT NULL,
  `medicine_name` varchar(250) NOT NULL,
  `dosage` varchar(250) DEFAULT NULL,
  `duration` varchar(250) NOT NULL,
  `time` varchar(250) NOT NULL,
  `dose_interval` varchar(250) NOT NULL,
  `notes` varchar(250) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `referral_requests`
--

CREATE TABLE `referral_requests` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `patient_id` bigint(20) UNSIGNED NOT NULL,
  `from_clinic_id` bigint(20) UNSIGNED NOT NULL,
  `to_clinic_id` bigint(20) UNSIGNED NOT NULL,
  `status` enum('Pending','Approved','Rejected') DEFAULT 'Pending',
  `requested_by` bigint(20) UNSIGNED NOT NULL,
  `approved_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `guard_name` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `is_super_admin_role` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `guard_name`, `created_at`, `updated_at`, `is_super_admin_role`) VALUES
(14, 'Super Admin', NULL, '2024-08-15 11:26:04', '2024-08-15 11:48:07', 0),
(16, 'Front Desk', NULL, '2024-08-15 11:26:25', '2025-01-06 12:59:32', 0),
(18, 'Doctor', NULL, '2024-08-15 11:26:25', '2024-12-20 07:19:30', 0),
(20, 'Accountant', NULL, '2024-12-31 09:10:58', '2024-12-31 09:10:58', 0),
(21, 'Clinic', NULL, '2024-12-31 09:10:58', '2024-12-31 09:10:58', 0);

-- --------------------------------------------------------

--
-- Table structure for table `role_permission`
--

CREATE TABLE `role_permission` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `permission_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `role_permission`
--

INSERT INTO `role_permission` (`id`, `role_id`, `permission_id`, `created_at`, `updated_at`) VALUES
(2621, 14, 1, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2622, 14, 2, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2623, 14, 3, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2624, 14, 4, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2625, 14, 5, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2626, 14, 6, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2627, 14, 7, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2628, 14, 8, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2629, 14, 9, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2630, 14, 10, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2631, 14, 11, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2632, 14, 12, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2633, 14, 13, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2634, 14, 14, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2635, 14, 15, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2636, 14, 16, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2637, 14, 17, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2638, 14, 18, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2639, 14, 19, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2640, 14, 20, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2641, 14, 21, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2642, 14, 22, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2643, 14, 23, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2644, 14, 24, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2645, 14, 25, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2646, 14, 26, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2647, 14, 27, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2648, 14, 28, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2649, 14, 29, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2650, 14, 30, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2651, 14, 31, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2652, 14, 32, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2653, 14, 33, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2654, 14, 34, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2655, 14, 35, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2656, 14, 36, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2657, 14, 37, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2658, 14, 38, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2659, 14, 39, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2660, 14, 40, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2661, 14, 41, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2662, 14, 42, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2663, 14, 43, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2664, 14, 44, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2665, 14, 45, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2666, 14, 46, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2667, 14, 48, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2668, 14, 49, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2669, 14, 50, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2670, 14, 55, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2671, 14, 56, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2672, 14, 57, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2673, 14, 58, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2674, 14, 59, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2675, 14, 60, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2676, 14, 61, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2677, 14, 62, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2678, 14, 63, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2679, 14, 64, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2680, 14, 65, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2681, 14, 66, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2682, 14, 67, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2683, 14, 68, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2684, 14, 69, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2685, 14, 70, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2686, 14, 75, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2687, 14, 76, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2688, 14, 77, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2689, 14, 78, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2690, 14, 79, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2691, 14, 80, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2692, 14, 81, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2693, 14, 82, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2694, 14, 83, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2695, 14, 84, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2696, 14, 85, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(2697, 14, 86, '2025-02-24 13:01:04', '2025-02-24 13:01:04'),
(3155, 20, 35, '2025-03-29 10:39:21', '2025-03-29 10:39:21'),
(3156, 20, 36, '2025-03-29 10:39:21', '2025-03-29 10:39:21'),
(3157, 20, 1, '2025-03-29 10:39:21', '2025-03-29 10:39:21'),
(3158, 20, 2, '2025-03-29 10:39:21', '2025-03-29 10:39:21'),
(3159, 20, 3, '2025-03-29 10:39:21', '2025-03-29 10:39:21'),
(3361, 16, 3, '2025-04-06 05:12:56', '2025-04-06 05:12:56'),
(3362, 16, 4, '2025-04-06 05:12:56', '2025-04-06 05:12:56'),
(3363, 16, 1, '2025-04-06 05:12:56', '2025-04-06 05:12:56'),
(3364, 16, 2, '2025-04-06 05:12:56', '2025-04-06 05:12:56'),
(3365, 16, 7, '2025-04-06 05:12:56', '2025-04-06 05:12:56'),
(3366, 16, 6, '2025-04-06 05:12:56', '2025-04-06 05:12:56'),
(3367, 16, 5, '2025-04-06 05:12:56', '2025-04-06 05:12:56'),
(3368, 16, 8, '2025-04-06 05:12:56', '2025-04-06 05:12:56'),
(3369, 16, 9, '2025-04-06 05:12:56', '2025-04-06 05:12:56'),
(3370, 16, 15, '2025-04-06 05:12:56', '2025-04-06 05:12:56'),
(3371, 16, 13, '2025-04-06 05:12:56', '2025-04-06 05:12:56'),
(3372, 16, 17, '2025-04-06 05:12:56', '2025-04-06 05:12:56'),
(3373, 16, 21, '2025-04-06 05:12:56', '2025-04-06 05:12:56'),
(3374, 16, 33, '2025-04-06 05:12:56', '2025-04-06 05:12:56'),
(3375, 16, 34, '2025-04-06 05:12:56', '2025-04-06 05:12:56'),
(3376, 16, 35, '2025-04-06 05:12:56', '2025-04-06 05:12:56'),
(3377, 16, 37, '2025-04-06 05:12:56', '2025-04-06 05:12:56'),
(3378, 16, 42, '2025-04-06 05:12:56', '2025-04-06 05:12:56'),
(3379, 16, 43, '2025-04-06 05:12:56', '2025-04-06 05:12:56'),
(3380, 16, 41, '2025-04-06 05:12:56', '2025-04-06 05:12:56'),
(3381, 16, 44, '2025-04-06 05:12:56', '2025-04-06 05:12:56'),
(3382, 16, 46, '2025-04-06 05:12:56', '2025-04-06 05:12:56'),
(3383, 16, 55, '2025-04-06 05:12:56', '2025-04-06 05:12:56'),
(3384, 16, 67, '2025-04-06 05:12:56', '2025-04-06 05:12:56'),
(3385, 16, 70, '2025-04-06 05:12:56', '2025-04-06 05:12:56'),
(3386, 16, 69, '2025-04-06 05:12:56', '2025-04-06 05:12:56'),
(3387, 16, 68, '2025-04-06 05:12:56', '2025-04-06 05:12:56'),
(3388, 16, 76, '2025-04-06 05:12:56', '2025-04-06 05:12:56'),
(3389, 16, 77, '2025-04-06 05:12:56', '2025-04-06 05:12:56'),
(3390, 16, 75, '2025-04-06 05:12:56', '2025-04-06 05:12:56'),
(3391, 16, 85, '2025-04-06 05:12:56', '2025-04-06 05:12:56'),
(3392, 16, 86, '2025-04-06 05:12:56', '2025-04-06 05:12:56'),
(3393, 16, 84, '2025-04-06 05:12:56', '2025-04-06 05:12:56'),
(3394, 16, 83, '2025-04-06 05:12:56', '2025-04-06 05:12:56'),
(3505, 21, 1, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3506, 21, 2, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3507, 21, 4, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3508, 21, 3, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3509, 21, 5, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3510, 21, 7, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3511, 21, 6, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3512, 21, 8, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3513, 21, 10, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3514, 21, 9, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3515, 21, 12, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3516, 21, 11, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3517, 21, 23, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3518, 21, 22, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3519, 21, 21, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3520, 21, 24, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3521, 21, 33, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3522, 21, 34, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3523, 21, 36, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3524, 21, 35, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3525, 21, 38, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3526, 21, 39, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3527, 21, 40, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3528, 21, 37, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3529, 21, 44, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3530, 21, 43, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3531, 21, 42, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3532, 21, 41, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3533, 21, 57, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3534, 21, 56, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3535, 21, 55, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3536, 21, 58, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3537, 21, 63, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3538, 21, 66, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3539, 21, 65, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3540, 21, 64, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3541, 21, 69, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3542, 21, 68, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3543, 21, 67, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3544, 21, 70, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3545, 21, 77, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3546, 21, 78, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3547, 21, 75, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3548, 21, 76, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3549, 21, 81, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3550, 21, 80, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3551, 21, 79, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3552, 21, 82, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3553, 21, 86, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3554, 21, 85, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3555, 21, 84, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3556, 21, 83, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3557, 21, 95, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3558, 21, 87, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3559, 21, 88, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3560, 21, 90, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3561, 21, 89, '2025-04-18 04:51:40', '2025-04-18 04:51:40'),
(3649, 18, 5, '2025-04-18 07:05:40', '2025-04-18 07:05:40'),
(3650, 18, 6, '2025-04-18 07:05:40', '2025-04-18 07:05:40'),
(3651, 18, 7, '2025-04-18 07:05:40', '2025-04-18 07:05:40'),
(3652, 18, 8, '2025-04-18 07:05:40', '2025-04-18 07:05:40'),
(3653, 18, 9, '2025-04-18 07:05:40', '2025-04-18 07:05:40'),
(3654, 18, 22, '2025-04-18 07:05:40', '2025-04-18 07:05:40'),
(3655, 18, 21, '2025-04-18 07:05:40', '2025-04-18 07:05:40'),
(3656, 18, 23, '2025-04-18 07:05:40', '2025-04-18 07:05:40'),
(3657, 18, 24, '2025-04-18 07:05:40', '2025-04-18 07:05:40'),
(3658, 18, 38, '2025-04-18 07:05:40', '2025-04-18 07:05:40'),
(3659, 18, 40, '2025-04-18 07:05:40', '2025-04-18 07:05:40'),
(3660, 18, 39, '2025-04-18 07:05:40', '2025-04-18 07:05:40'),
(3661, 18, 37, '2025-04-18 07:05:40', '2025-04-18 07:05:40'),
(3662, 18, 44, '2025-04-18 07:05:40', '2025-04-18 07:05:40'),
(3663, 18, 41, '2025-04-18 07:05:40', '2025-04-18 07:05:40'),
(3664, 18, 42, '2025-04-18 07:05:40', '2025-04-18 07:05:40'),
(3665, 18, 56, '2025-04-18 07:05:40', '2025-04-18 07:05:40'),
(3666, 18, 57, '2025-04-18 07:05:40', '2025-04-18 07:05:40'),
(3667, 18, 58, '2025-04-18 07:05:40', '2025-04-18 07:05:40'),
(3668, 18, 55, '2025-04-18 07:05:40', '2025-04-18 07:05:40'),
(3669, 18, 75, '2025-04-18 07:05:40', '2025-04-18 07:05:40'),
(3670, 18, 67, '2025-04-18 07:05:40', '2025-04-18 07:05:40');

-- --------------------------------------------------------

--
-- Table structure for table `social_media`
--

CREATE TABLE `social_media` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(250) NOT NULL,
  `image` text DEFAULT NULL,
  `url` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `specialization`
--

CREATE TABLE `specialization` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(250) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `states`
--

CREATE TABLE `states` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(250) NOT NULL,
  `country_id` bigint(20) UNSIGNED NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL,
  `updated_at` timestamp NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `testimonials`
--

CREATE TABLE `testimonials` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `clinic_id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(250) NOT NULL,
  `sub_title` varchar(250) NOT NULL,
  `image` text DEFAULT NULL,
  `rating` int(11) NOT NULL,
  `description` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `time_slots`
--

CREATE TABLE `time_slots` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `doct_id` bigint(20) UNSIGNED NOT NULL,
  `time_start` time NOT NULL,
  `time_end` time NOT NULL,
  `time_duration` int(11) NOT NULL,
  `day` enum('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday') NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `transaction`
--

CREATE TABLE `transaction` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `patient_id` bigint(20) UNSIGNED DEFAULT NULL,
  `payment_transaction_id` text DEFAULT NULL,
  `amount` double NOT NULL,
  `transaction_type` enum('Credited','Debited') NOT NULL,
  `is_wallet_txn` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `clinic_id` bigint(20) UNSIGNED DEFAULT NULL,
  `wallet_amount` double DEFAULT 0,
  `f_name` varchar(255) NOT NULL,
  `l_name` varchar(250) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `isd_code` varchar(6) DEFAULT NULL,
  `gender` enum('Male','Female','Other','') DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `image` varchar(250) DEFAULT NULL,
  `address` varchar(250) DEFAULT NULL,
  `city` varchar(250) DEFAULT NULL,
  `state` varchar(250) DEFAULT NULL,
  `postal_code` int(11) DEFAULT NULL,
  `isd_code_sec` varchar(6) DEFAULT NULL,
  `phone_sec` varchar(20) DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `fcm` text DEFAULT NULL,
  `web_fcm` text DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `notification_seen_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users_role_assign`
--

CREATE TABLE `users_role_assign` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_address`
--

CREATE TABLE `user_address` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(250) NOT NULL,
  `s_phone` varchar(250) NOT NULL,
  `flat_no` varchar(250) DEFAULT NULL,
  `apartment_name` varchar(250) DEFAULT NULL,
  `area` varchar(250) NOT NULL,
  `landmark` varchar(250) NOT NULL,
  `city` varchar(250) NOT NULL,
  `pincode` int(11) NOT NULL,
  `lat` double DEFAULT NULL,
  `lng` double DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_notification`
--

CREATE TABLE `user_notification` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `appointment_id` bigint(20) UNSIGNED DEFAULT NULL,
  `txn_id` bigint(20) UNSIGNED DEFAULT NULL,
  `prescription_id` bigint(20) UNSIGNED DEFAULT NULL,
  `file_id` bigint(20) UNSIGNED DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `title` varchar(250) NOT NULL,
  `body` varchar(250) NOT NULL,
  `image` text DEFAULT NULL,
  `type` enum('Normal','Appointment','Transaction') DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `video_time_slots`
--

CREATE TABLE `video_time_slots` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `doct_id` bigint(20) UNSIGNED NOT NULL,
  `time_start` time NOT NULL,
  `time_end` time NOT NULL,
  `time_duration` int(11) NOT NULL,
  `day` enum('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday') NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `vitals_measurements`
--

CREATE TABLE `vitals_measurements` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `family_member_id` bigint(20) UNSIGNED NOT NULL,
  `bp_systolic` double DEFAULT NULL COMMENT 'mmHg',
  `bp_diastolic` double DEFAULT NULL COMMENT 'mmHg',
  `weight` double DEFAULT NULL COMMENT 'kg',
  `spo2` double DEFAULT NULL COMMENT 'percentage',
  `temperature` double DEFAULT NULL COMMENT 'F',
  `sugar_random` double DEFAULT NULL COMMENT 'Mg/dl',
  `sugar_fasting` double DEFAULT NULL,
  `type` enum('Blood Pressure','Sugar','SpO2','Weight','Temperature') DEFAULT NULL,
  `date` date DEFAULT NULL,
  `time` time DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `webhook_centrelize_data_log`
--

CREATE TABLE `webhook_centrelize_data_log` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `payload` text DEFAULT NULL,
  `payment_id` varchar(250) DEFAULT NULL,
  `response` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `webhook_log`
--

CREATE TABLE `webhook_log` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `payment_id` text DEFAULT NULL,
  `status` varchar(250) DEFAULT NULL,
  `response` text DEFAULT NULL,
  `payload` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `web_pages`
--

CREATE TABLE `web_pages` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `page_id` int(11) NOT NULL COMMENT '	1=about us,2=privacy,3=terms	 , 4=about us doctor app,5=privacy doctor app,6=terms doctor app	',
  `title` varchar(250) NOT NULL,
  `body` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin_notification`
--
ALTER TABLE `admin_notification`
  ADD PRIMARY KEY (`id`),
  ADD KEY `admin_notification_appointment_id` (`appointment_id`),
  ADD KEY `admin_notification_txn_id` (`txn_id`);

--
-- Indexes for table `all_transaction`
--
ALTER TABLE `all_transaction`
  ADD PRIMARY KEY (`id`),
  ADD KEY `appointment_transaction_user_id` (`user_id`),
  ADD KEY `appointment_transaction_patient_id` (`patient_id`),
  ADD KEY `appointment_transaction_appointment_id` (`appointment_id`),
  ADD KEY `appointment_transaction_clinic_id` (`clinic_id`);

--
-- Indexes for table `appointments`
--
ALTER TABLE `appointments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `app_doct_id` (`doct_id`),
  ADD KEY `app_dept_id` (`dept_id`),
  ADD KEY `app_patient_id` (`patient_id`),
  ADD KEY `app_clinic_id` (`clinic_id`);

--
-- Indexes for table `appointments_invoice_item`
--
ALTER TABLE `appointments_invoice_item`
  ADD PRIMARY KEY (`id`),
  ADD KEY `appointments_invoice_item_invoice_id` (`invoice_id`),
  ADD KEY `appointments_invoice_item_clinic_id` (`clinic_id`);

--
-- Indexes for table `appointment_cancellation_req`
--
ALTER TABLE `appointment_cancellation_req`
  ADD PRIMARY KEY (`id`),
  ADD KEY `appointment_cancellation_req_app_id` (`appointment_id`);

--
-- Indexes for table `appointment_checkin`
--
ALTER TABLE `appointment_checkin`
  ADD PRIMARY KEY (`id`),
  ADD KEY `checkin_appointment_id` (`appointment_id`),
  ADD KEY `checkin_clinic_id` (`clinic_id`);

--
-- Indexes for table `appointment_invoice`
--
ALTER TABLE `appointment_invoice`
  ADD PRIMARY KEY (`id`),
  ADD KEY `appointment_invoice_user_id` (`user_id`),
  ADD KEY `appointment_invoice_patient_id` (`patient_id`),
  ADD KEY `appointment_invoice_appointment_id` (`appointment_id`),
  ADD KEY `appointment_invoice_clinic_id` (`clinic_id`);

--
-- Indexes for table `appointment_payments`
--
ALTER TABLE `appointment_payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `appointment_payments_txn_id` (`txn_id`),
  ADD KEY `appointment_payments_invoice_id` (`invoice_id`),
  ADD KEY `appointment_payments_clinic_id` (`clinic_id`);

--
-- Indexes for table `appointment_status_log`
--
ALTER TABLE `appointment_status_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `asl_user_id` (`user_id`),
  ADD KEY `asl_appointment_id` (`appointment_id`),
  ADD KEY `asl_patient_id` (`patient_id`),
  ADD KEY `asl_clinic_id` (`clinic_id`);

--
-- Indexes for table `banners`
--
ALTER TABLE `banners`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cities`
--
ALTER TABLE `cities`
  ADD PRIMARY KEY (`id`),
  ADD KEY `city_state_id` (`state_id`);

--
-- Indexes for table `clinics`
--
ALTER TABLE `clinics`
  ADD PRIMARY KEY (`id`),
  ADD KEY `clinic_user_id` (`user_id`),
  ADD KEY `clinic_city_id` (`city_id`);

--
-- Indexes for table `clinic_images`
--
ALTER TABLE `clinic_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `clinic_image_clinic_id` (`clinic_id`);

--
-- Indexes for table `configurations`
--
ALTER TABLE `configurations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `contact_form_inbox`
--
ALTER TABLE `contact_form_inbox`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `country`
--
ALTER TABLE `country`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `coupon`
--
ALTER TABLE `coupon`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `coupon_use`
--
ALTER TABLE `coupon_use`
  ADD PRIMARY KEY (`id`),
  ADD KEY `coupon_use_appointment_id_id` (`appointment_id`),
  ADD KEY `coupon_use_user_id` (`user_id`),
  ADD KEY `coupon_use_coupon_id` (`coupon_id`),
  ADD KEY `coupon_use_clinic_id` (`clinic_id`);

--
-- Indexes for table `department`
--
ALTER TABLE `department`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `title` (`title`);

--
-- Indexes for table `doctors`
--
ALTER TABLE `doctors`
  ADD PRIMARY KEY (`id`),
  ADD KEY `doctor_users_id` (`user_id`),
  ADD KEY `doctor_dept_id` (`department`),
  ADD KEY `doctor_clinic_id` (`clinic_id`);

--
-- Indexes for table `doctors_review`
--
ALTER TABLE `doctors_review`
  ADD PRIMARY KEY (`id`),
  ADD KEY `doctors_review_doct_id` (`doctor_id`),
  ADD KEY `doctors_review_appointment_id` (`appointment_id`),
  ADD KEY `doctors_review_user_id` (`user_id`),
  ADD KEY `doctors_review_clinic_id` (`clinic_id`);

--
-- Indexes for table `doctor_notification`
--
ALTER TABLE `doctor_notification`
  ADD PRIMARY KEY (`id`),
  ADD KEY `doctor_notification_doctor_id` (`doctor_id`),
  ADD KEY ` doctr_notification_appointment_id` (`appointment_id`),
  ADD KEY `doctor_notification_prescription_id` (`prescription_id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `family_members`
--
ALTER TABLE `family_members`
  ADD PRIMARY KEY (`id`),
  ADD KEY `family_member_user_id` (`user_id`);

--
-- Indexes for table `login_screen_image`
--
ALTER TABLE `login_screen_image`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `patients`
--
ALTER TABLE `patients`
  ADD PRIMARY KEY (`id`),
  ADD KEY `patient_user_id` (`user_id`),
  ADD KEY `patient_clinic_id` (`clinic_id`);

--
-- Indexes for table `patient_clinic`
--
ALTER TABLE `patient_clinic`
  ADD PRIMARY KEY (`id`),
  ADD KEY `patient_clinic_clinic_id` (`clinic_id`),
  ADD KEY `patient_clinic_patient_id` (`patient_id`),
  ADD KEY `patient_clinic_referral_request_id` (`referral_requests_id`);

--
-- Indexes for table `patient_files`
--
ALTER TABLE `patient_files`
  ADD PRIMARY KEY (`id`),
  ADD KEY `patient_files_patient_id` (`patient_id`),
  ADD KEY `patient_files_clinic_id` (`clinic_id`);

--
-- Indexes for table `payment_gateway`
--
ALTER TABLE `payment_gateway`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `permission`
--
ALTER TABLE `permission`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `prescribe_medicines`
--
ALTER TABLE `prescribe_medicines`
  ADD PRIMARY KEY (`id`),
  ADD KEY `medicine_clinic_id` (`clinic_id`);

--
-- Indexes for table `prescription`
--
ALTER TABLE `prescription`
  ADD PRIMARY KEY (`id`),
  ADD KEY `prescription_appointment_id` (`appointment_id`),
  ADD KEY `prescription_patient_id` (`patient_id`),
  ADD KEY `prescription_patient_clinic_id` (`clinic_id`);

--
-- Indexes for table `prescription_item`
--
ALTER TABLE `prescription_item`
  ADD PRIMARY KEY (`id`),
  ADD KEY `prescription_item_prescription_id` (`prescription_id`);

--
-- Indexes for table `referral_requests`
--
ALTER TABLE `referral_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `referral_requests_patient` (`patient_id`),
  ADD KEY `referral_requests_from_clinic` (`from_clinic_id`),
  ADD KEY `referral_requests_to_clinic` (`to_clinic_id`),
  ADD KEY `referral_requests_requested_by` (`requested_by`),
  ADD KEY `referral_requests_approved_by` (`approved_by`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roles_name_guard_name_unique` (`name`,`guard_name`);

--
-- Indexes for table `role_permission`
--
ALTER TABLE `role_permission`
  ADD PRIMARY KEY (`id`),
  ADD KEY `role_permission_role_id` (`role_id`),
  ADD KEY `role_permission_permission_id` (`permission_id`);

--
-- Indexes for table `social_media`
--
ALTER TABLE `social_media`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `specialization`
--
ALTER TABLE `specialization`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `title` (`title`);

--
-- Indexes for table `states`
--
ALTER TABLE `states`
  ADD PRIMARY KEY (`id`),
  ADD KEY `states_country_id` (`country_id`);

--
-- Indexes for table `testimonials`
--
ALTER TABLE `testimonials`
  ADD PRIMARY KEY (`id`),
  ADD KEY `testimonial_clinic_id` (`clinic_id`);

--
-- Indexes for table `time_slots`
--
ALTER TABLE `time_slots`
  ADD PRIMARY KEY (`id`),
  ADD KEY `time_slots_doct_id` (`doct_id`);

--
-- Indexes for table `transaction`
--
ALTER TABLE `transaction`
  ADD PRIMARY KEY (`id`),
  ADD KEY `txn_user_id` (`user_id`),
  ADD KEY `txn_patient_id` (`patient_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD KEY `users_clinic_id` (`clinic_id`);

--
-- Indexes for table `users_role_assign`
--
ALTER TABLE `users_role_assign`
  ADD PRIMARY KEY (`id`),
  ADD KEY `users_role_assign_user_id` (`user_id`),
  ADD KEY `users_role_assign_role_id` (`role_id`);

--
-- Indexes for table `user_address`
--
ALTER TABLE `user_address`
  ADD PRIMARY KEY (`id`),
  ADD KEY `address_user_id` (`user_id`);

--
-- Indexes for table `user_notification`
--
ALTER TABLE `user_notification`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_notification_user_id` (`user_id`),
  ADD KEY `user_notification_appointment_id` (`appointment_id`),
  ADD KEY `user_notification_txn_id` (`txn_id`),
  ADD KEY `user_notification_prescription_id` (`prescription_id`);

--
-- Indexes for table `video_time_slots`
--
ALTER TABLE `video_time_slots`
  ADD PRIMARY KEY (`id`),
  ADD KEY `video_time_slots_doct_id` (`doct_id`);

--
-- Indexes for table `vitals_measurements`
--
ALTER TABLE `vitals_measurements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `vital_user_id` (`user_id`),
  ADD KEY `vital_family_member_id` (`family_member_id`);

--
-- Indexes for table `webhook_centrelize_data_log`
--
ALTER TABLE `webhook_centrelize_data_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `webhook_log`
--
ALTER TABLE `webhook_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `web_pages`
--
ALTER TABLE `web_pages`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin_notification`
--
ALTER TABLE `admin_notification`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `all_transaction`
--
ALTER TABLE `all_transaction`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `appointments`
--
ALTER TABLE `appointments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `appointments_invoice_item`
--
ALTER TABLE `appointments_invoice_item`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `appointment_cancellation_req`
--
ALTER TABLE `appointment_cancellation_req`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `appointment_checkin`
--
ALTER TABLE `appointment_checkin`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `appointment_invoice`
--
ALTER TABLE `appointment_invoice`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `appointment_payments`
--
ALTER TABLE `appointment_payments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `appointment_status_log`
--
ALTER TABLE `appointment_status_log`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `banners`
--
ALTER TABLE `banners`
  MODIFY `id` bigint(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cities`
--
ALTER TABLE `cities`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `clinics`
--
ALTER TABLE `clinics`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `clinic_images`
--
ALTER TABLE `clinic_images`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `configurations`
--
ALTER TABLE `configurations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `contact_form_inbox`
--
ALTER TABLE `contact_form_inbox`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `country`
--
ALTER TABLE `country`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `coupon`
--
ALTER TABLE `coupon`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `coupon_use`
--
ALTER TABLE `coupon_use`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `department`
--
ALTER TABLE `department`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `doctors`
--
ALTER TABLE `doctors`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `doctors_review`
--
ALTER TABLE `doctors_review`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `doctor_notification`
--
ALTER TABLE `doctor_notification`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `family_members`
--
ALTER TABLE `family_members`
  MODIFY `id` bigint(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `login_screen_image`
--
ALTER TABLE `login_screen_image`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `patients`
--
ALTER TABLE `patients`
  MODIFY `id` bigint(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `patient_clinic`
--
ALTER TABLE `patient_clinic`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `patient_files`
--
ALTER TABLE `patient_files`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `payment_gateway`
--
ALTER TABLE `payment_gateway`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `permission`
--
ALTER TABLE `permission`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=96;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `prescribe_medicines`
--
ALTER TABLE `prescribe_medicines`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `prescription`
--
ALTER TABLE `prescription`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `prescription_item`
--
ALTER TABLE `prescription_item`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `referral_requests`
--
ALTER TABLE `referral_requests`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `role_permission`
--
ALTER TABLE `role_permission`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3671;

--
-- AUTO_INCREMENT for table `social_media`
--
ALTER TABLE `social_media`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `specialization`
--
ALTER TABLE `specialization`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `states`
--
ALTER TABLE `states`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `testimonials`
--
ALTER TABLE `testimonials`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `time_slots`
--
ALTER TABLE `time_slots`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `transaction`
--
ALTER TABLE `transaction`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users_role_assign`
--
ALTER TABLE `users_role_assign`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_address`
--
ALTER TABLE `user_address`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_notification`
--
ALTER TABLE `user_notification`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `video_time_slots`
--
ALTER TABLE `video_time_slots`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `vitals_measurements`
--
ALTER TABLE `vitals_measurements`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `webhook_centrelize_data_log`
--
ALTER TABLE `webhook_centrelize_data_log`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `webhook_log`
--
ALTER TABLE `webhook_log`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `web_pages`
--
ALTER TABLE `web_pages`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `all_transaction`
--
ALTER TABLE `all_transaction`
  ADD CONSTRAINT `appointment_transaction_appointment_id` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`id`),
  ADD CONSTRAINT `appointment_transaction_clinic_id` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`),
  ADD CONSTRAINT `appointment_transaction_patient_id` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`),
  ADD CONSTRAINT `appointment_transaction_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `appointments`
--
ALTER TABLE `appointments`
  ADD CONSTRAINT `app_clinic_id` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`),
  ADD CONSTRAINT `app_dept_id` FOREIGN KEY (`dept_id`) REFERENCES `department` (`id`),
  ADD CONSTRAINT `app_doct_id` FOREIGN KEY (`doct_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `app_patient_id` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`);

--
-- Constraints for table `appointments_invoice_item`
--
ALTER TABLE `appointments_invoice_item`
  ADD CONSTRAINT `appointments_invoice_item_clinic_id` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`),
  ADD CONSTRAINT `appointments_invoice_item_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `appointment_invoice` (`id`);

--
-- Constraints for table `appointment_cancellation_req`
--
ALTER TABLE `appointment_cancellation_req`
  ADD CONSTRAINT `appointment_cancellation_req_app_id` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`id`);

--
-- Constraints for table `appointment_checkin`
--
ALTER TABLE `appointment_checkin`
  ADD CONSTRAINT `checkin_appointment_id` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`id`),
  ADD CONSTRAINT `checkin_clinic_id` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`);

--
-- Constraints for table `appointment_invoice`
--
ALTER TABLE `appointment_invoice`
  ADD CONSTRAINT `appointment_invoice_appointment_id` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`id`),
  ADD CONSTRAINT `appointment_invoice_clinic_id` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`),
  ADD CONSTRAINT `appointment_invoice_patient_id` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`),
  ADD CONSTRAINT `appointment_invoice_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `appointment_payments`
--
ALTER TABLE `appointment_payments`
  ADD CONSTRAINT `appointment_payments_clinic_id` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`),
  ADD CONSTRAINT `appointment_payments_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `appointment_invoice` (`id`),
  ADD CONSTRAINT `appointment_payments_txn_id` FOREIGN KEY (`txn_id`) REFERENCES `all_transaction` (`id`);

--
-- Constraints for table `appointment_status_log`
--
ALTER TABLE `appointment_status_log`
  ADD CONSTRAINT `asl_appointment_id` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`id`),
  ADD CONSTRAINT `asl_clinic_id` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`),
  ADD CONSTRAINT `asl_patient_id` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`),
  ADD CONSTRAINT `asl_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `cities`
--
ALTER TABLE `cities`
  ADD CONSTRAINT `city_state_id` FOREIGN KEY (`state_id`) REFERENCES `states` (`id`);

--
-- Constraints for table `clinics`
--
ALTER TABLE `clinics`
  ADD CONSTRAINT `clinic_city_id` FOREIGN KEY (`city_id`) REFERENCES `cities` (`id`),
  ADD CONSTRAINT `clinic_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `clinic_images`
--
ALTER TABLE `clinic_images`
  ADD CONSTRAINT `clinic_image_clinic_id` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`);

--
-- Constraints for table `coupon_use`
--
ALTER TABLE `coupon_use`
  ADD CONSTRAINT `coupon_use_appointment_id_id` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`id`),
  ADD CONSTRAINT `coupon_use_clinic_id` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`),
  ADD CONSTRAINT `coupon_use_coupon_id` FOREIGN KEY (`coupon_id`) REFERENCES `coupon` (`id`),
  ADD CONSTRAINT `coupon_use_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `doctors`
--
ALTER TABLE `doctors`
  ADD CONSTRAINT `doctor_clinic_id` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`),
  ADD CONSTRAINT `doctor_dept_id` FOREIGN KEY (`department`) REFERENCES `department` (`id`),
  ADD CONSTRAINT `doctor_users_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `doctors_review`
--
ALTER TABLE `doctors_review`
  ADD CONSTRAINT `doctors_review_appointment_id` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`id`),
  ADD CONSTRAINT `doctors_review_clinic_id` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`),
  ADD CONSTRAINT `doctors_review_doct_id` FOREIGN KEY (`doctor_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `doctors_review_user_id` FOREIGN KEY (`user_id`) REFERENCES `patients` (`id`);

--
-- Constraints for table `family_members`
--
ALTER TABLE `family_members`
  ADD CONSTRAINT `family_member_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `patients`
--
ALTER TABLE `patients`
  ADD CONSTRAINT `patient_clinic_id` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`),
  ADD CONSTRAINT `patient_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `patient_clinic`
--
ALTER TABLE `patient_clinic`
  ADD CONSTRAINT `patient_clinic_clinic_id` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`),
  ADD CONSTRAINT `patient_clinic_patient_id` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`),
  ADD CONSTRAINT `patient_clinic_referral_request_id` FOREIGN KEY (`referral_requests_id`) REFERENCES `referral_requests` (`id`);

--
-- Constraints for table `patient_files`
--
ALTER TABLE `patient_files`
  ADD CONSTRAINT `patient_files_clinic_id` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`),
  ADD CONSTRAINT `patient_files_patient_id` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`);

--
-- Constraints for table `prescribe_medicines`
--
ALTER TABLE `prescribe_medicines`
  ADD CONSTRAINT `medicine_clinic_id` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`);

--
-- Constraints for table `prescription`
--
ALTER TABLE `prescription`
  ADD CONSTRAINT `prescription_appointment_id` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`id`),
  ADD CONSTRAINT `prescription_patient_clinic_id` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`),
  ADD CONSTRAINT `prescription_patient_id` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`);

--
-- Constraints for table `prescription_item`
--
ALTER TABLE `prescription_item`
  ADD CONSTRAINT `prescription_item_prescription_id` FOREIGN KEY (`prescription_id`) REFERENCES `prescription` (`id`);

--
-- Constraints for table `referral_requests`
--
ALTER TABLE `referral_requests`
  ADD CONSTRAINT `referral_requests_approved_by` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `referral_requests_from_clinic` FOREIGN KEY (`from_clinic_id`) REFERENCES `clinics` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `referral_requests_patient` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `referral_requests_requested_by` FOREIGN KEY (`requested_by`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `referral_requests_to_clinic` FOREIGN KEY (`to_clinic_id`) REFERENCES `clinics` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `role_permission`
--
ALTER TABLE `role_permission`
  ADD CONSTRAINT `role_permission_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `permission` (`id`),
  ADD CONSTRAINT `role_permission_role_id` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);

--
-- Constraints for table `states`
--
ALTER TABLE `states`
  ADD CONSTRAINT `states_country_id` FOREIGN KEY (`country_id`) REFERENCES `country` (`id`);

--
-- Constraints for table `testimonials`
--
ALTER TABLE `testimonials`
  ADD CONSTRAINT `testimonial_clinic_id` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_clinic_id` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`);

--
-- Constraints for table `users_role_assign`
--
ALTER TABLE `users_role_assign`
  ADD CONSTRAINT `users_role_assign_role_id` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  ADD CONSTRAINT `users_role_assign_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `vitals_measurements`
--
ALTER TABLE `vitals_measurements`
  ADD CONSTRAINT `vital_family_member_id` FOREIGN KEY (`family_member_id`) REFERENCES `family_members` (`id`),
  ADD CONSTRAINT `vital_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
