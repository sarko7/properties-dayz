CREATE TABLE `property` (
	`UUID` UUID NOT NULL,
	`type` VARCHAR(50) NOT NULL DEFAULT 'property' COLLATE 'utf8mb4_uca1400_ai_ci',
	`owner` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8mb4_uca1400_ai_ci',
	`price_buy` INT(50) NULL DEFAULT NULL,
	`price_rental` INT(50) NULL DEFAULT NULL,
	`position` LONGTEXT NULL DEFAULT '[]' COLLATE 'utf8mb4_uca1400_ai_ci',
	`shellName` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_uca1400_ai_ci',
	`rental_deadline` INT(50) NULL DEFAULT NULL,
	`address` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_uca1400_ai_ci',
	`statue` INT(11) NULL DEFAULT '0',
	PRIMARY KEY (`UUID`) USING BTREE
)
COLLATE='utf8mb4_uca1400_ai_ci'
ENGINE=InnoDB
;