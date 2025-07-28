CREATE TABLE `property` (
	`uuid` UUID NOT NULL,
	`type` VARCHAR(25) NOT NULL DEFAULT 'house' COLLATE 'utf8mb4_uca1400_ai_ci',
	`owner` VARCHAR(25) NULL DEFAULT NULL COLLATE 'utf8mb4_uca1400_ai_ci',
	`position` LONGTEXT NOT NULL COLLATE 'utf8mb4_bin',
	`price` LONGTEXT NOT NULL COLLATE 'utf8mb4_bin',
	`shellName` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_uca1400_ai_ci',
	`rentalDeadline` TIMESTAMP NULL DEFAULT '0000-00-00 00:00:00',
	`statut` ENUM('Y','N') NULL DEFAULT NULL COLLATE 'utf8mb4_uca1400_ai_ci',
	`address` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_uca1400_ai_ci',
	PRIMARY KEY (`uuid`) USING BTREE,
	CONSTRAINT `position` CHECK (json_valid(`position`)),
	CONSTRAINT `price` CHECK (json_valid(`price`))
)
COLLATE='utf8mb4_uca1400_ai_ci'
ENGINE=InnoDB
;