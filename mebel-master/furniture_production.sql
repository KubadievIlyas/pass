-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Май 22 2025 г., 00:02
-- Версия сервера: 5.7.39
-- Версия PHP: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `furniture_production`
--

-- --------------------------------------------------------

--
-- Структура таблицы `material_types`
--

CREATE TABLE `material_types` (
  `material_type_id` int(11) NOT NULL,
  `material_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `loss_percentage` decimal(5,4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `material_types`
--

INSERT INTO `material_types` (`material_type_id`, `material_name`, `loss_percentage`) VALUES
(1, 'Мебельный щит из массива дерева', '0.0080'),
(2, 'Ламинированное ДСП', '0.0070'),
(3, 'Фанера', '0.0055'),
(4, 'МДФ', '0.0030');

-- --------------------------------------------------------

--
-- Структура таблицы `partner_requests`
--

CREATE TABLE `partner_requests` (
  `request_id` int(11) NOT NULL,
  `partner_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `request_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `total_cost` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `production_steps`
--

CREATE TABLE `production_steps` (
  `production_step_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `workshop_id` int(11) NOT NULL,
  `production_time_hours` decimal(4,1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `production_steps`
--

INSERT INTO `production_steps` (`production_step_id`, `product_id`, `workshop_id`, `production_time_hours`) VALUES
(1, 1, 1, '1.0'),
(2, 1, 3, '1.0'),
(3, 1, 4, '0.5'),
(4, 1, 7, '1.5'),
(5, 1, 5, '2.0'),
(6, 1, 6, '0.3'),
(7, 1, 12, '0.3'),
(8, 1, 2, '0.4'),
(9, 2, 1, '1.0'),
(10, 2, 3, '1.0'),
(11, 2, 4, '0.3'),
(12, 2, 7, '1.0'),
(13, 2, 5, '2.0'),
(14, 2, 6, '0.4'),
(15, 2, 12, '0.2'),
(16, 2, 2, '1.0'),
(17, 2, 10, '0.3'),
(18, 2, 11, '1.0'),
(19, 3, 3, '1.0'),
(20, 3, 4, '0.5'),
(21, 3, 10, '0.5'),
(22, 3, 11, '1.0'),
(23, 3, 12, '0.5'),
(24, 4, 3, '1.0'),
(25, 4, 4, '0.5'),
(26, 4, 12, '0.5'),
(27, 5, 1, '1.5'),
(28, 5, 2, '0.5'),
(29, 5, 3, '1.0'),
(30, 5, 4, '0.5'),
(31, 5, 5, '2.0'),
(32, 5, 6, '0.5'),
(33, 5, 7, '1.0'),
(34, 5, 10, '0.3'),
(35, 5, 11, '0.5'),
(36, 5, 12, '0.2'),
(37, 6, 3, '1.0'),
(38, 6, 4, '0.5'),
(39, 6, 5, '2.0'),
(40, 6, 6, '0.5'),
(41, 6, 9, '4.2'),
(42, 6, 11, '0.5'),
(43, 6, 12, '0.3'),
(44, 7, 3, '1.0'),
(45, 7, 4, '0.5'),
(46, 7, 5, '2.0'),
(47, 7, 6, '1.0'),
(48, 7, 7, '0.5'),
(49, 7, 9, '4.5'),
(50, 7, 11, '0.3'),
(51, 7, 12, '0.2'),
(52, 8, 1, '0.5'),
(53, 8, 2, '0.5'),
(54, 8, 3, '0.5'),
(55, 8, 4, '0.5'),
(56, 8, 5, '2.0'),
(57, 8, 6, '0.5'),
(58, 8, 7, '0.5'),
(59, 8, 9, '4.7'),
(60, 8, 11, '0.3'),
(61, 8, 12, '0.3'),
(62, 9, 3, '0.7'),
(63, 9, 4, '0.3'),
(64, 9, 6, '0.5'),
(65, 9, 7, '1.0'),
(66, 9, 9, '4.0'),
(67, 9, 11, '0.5'),
(68, 9, 12, '0.5'),
(69, 10, 8, '2.0'),
(70, 10, 4, '0.6'),
(71, 10, 3, '1.0'),
(72, 10, 6, '0.4'),
(73, 10, 10, '0.5'),
(74, 10, 12, '0.5'),
(75, 11, 3, '1.0'),
(76, 11, 4, '1.0'),
(77, 11, 9, '5.5'),
(78, 11, 12, '0.5'),
(79, 12, 3, '1.1'),
(80, 12, 4, '0.8'),
(81, 12, 11, '0.8'),
(82, 12, 12, '0.3'),
(83, 13, 3, '2.0'),
(84, 13, 4, '2.0'),
(85, 13, 6, '1.5'),
(86, 13, 11, '0.3'),
(87, 13, 12, '0.2'),
(88, 14, 1, '2.0'),
(89, 14, 2, '1.0'),
(90, 14, 3, '1.0'),
(91, 14, 4, '0.5'),
(92, 14, 10, '0.5'),
(93, 14, 11, '1.5'),
(94, 14, 12, '0.5'),
(95, 15, 1, '1.0'),
(96, 15, 2, '0.7'),
(97, 15, 3, '1.0'),
(98, 15, 4, '0.3'),
(99, 15, 5, '2.0'),
(100, 15, 6, '1.0'),
(101, 15, 7, '0.5'),
(102, 15, 11, '0.3'),
(103, 15, 12, '0.2'),
(104, 16, 3, '1.0'),
(105, 16, 4, '1.5'),
(106, 16, 7, '1.0'),
(107, 16, 11, '2.0'),
(108, 16, 12, '0.5'),
(109, 17, 3, '1.0'),
(110, 17, 4, '1.0'),
(111, 17, 6, '2.5'),
(112, 17, 7, '3.0'),
(113, 17, 12, '0.5'),
(114, 18, 3, '1.0'),
(115, 18, 4, '0.5'),
(116, 18, 5, '2.0'),
(117, 18, 6, '1.0'),
(118, 18, 7, '2.0'),
(119, 18, 11, '0.3'),
(120, 18, 12, '0.2'),
(121, 19, 3, '1.0'),
(122, 19, 4, '0.4'),
(123, 19, 5, '2.0'),
(124, 19, 6, '0.4'),
(125, 19, 7, '2.0'),
(126, 19, 12, '0.2'),
(127, 20, 1, '1.0'),
(128, 20, 2, '0.4'),
(129, 20, 3, '0.6'),
(130, 20, 4, '0.5'),
(131, 20, 6, '0.5'),
(132, 20, 8, '2.7'),
(133, 20, 10, '1.0'),
(134, 20, 11, '1.0'),
(135, 20, 12, '0.3');

-- --------------------------------------------------------

--
-- Структура таблицы `products`
--

CREATE TABLE `products` (
  `product_id` int(11) NOT NULL,
  `product_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `article_number` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `min_partner_price` decimal(10,2) NOT NULL,
  `category_id` int(11) NOT NULL,
  `main_material_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `products`
--

INSERT INTO `products` (`product_id`, `product_name`, `article_number`, `min_partner_price`, `category_id`, `main_material_id`) VALUES
(1, 'Комплект мебели для гостиной Ольха горная', '1549922', '160507.00', 1, 1),
(2, 'Стенка для гостиной Вишня темная', '1018556', '216907.00', 1, 1),
(3, 'Прихожая Венге Винтаж', '3028272', '24970.00', 2, 2),
(4, 'Тумба с вешалкой Дуб натуральный', '3029272', '18206.00', 2, 2),
(5, 'Прихожая-комплект Дуб темный', '3028248', '177509.00', 2, 1),
(6, 'Диван-кровать угловой Книжка', '7118827', '85900.00', 3, 1),
(7, 'Диван модульный Телескоп', '7137981', '75900.00', 3, 1),
(8, 'Диван-кровать Соло', '7029787', '120345.00', 3, 1),
(9, 'Детский диван Выкатной', '7758953', '25990.00', 3, 3),
(10, 'Кровать с подъемным механизмом с матрасом 1600х2000 Венге', '6026662', '69500.00', 4, 1),
(11, 'Кровать с матрасом 90х2000 Венге', '6159043', '55600.00', 4, 2),
(12, 'Кровать универсальная Дуб натуральный', '6588376', '37900.00', 4, 2),
(13, 'Кровать с ящиками Ясень белый', '6758375', '46750.00', 4, 3),
(14, 'Шкаф-купе 3-х дверный Сосна белая', '2759324', '131560.00', 5, 2),
(15, 'Стеллаж Бук натуральный', '2118827', '38700.00', 5, 1),
(16, 'Шкаф 4 дверный с ящиками Ясень серый', '2559898', '160151.00', 5, 3),
(17, 'Шкаф-пенал Береза белый', '2259474', '40500.00', 5, 3),
(18, 'Комод 6 ящиков Вишня светлая', '4115947', '61235.00', 6, 1),
(19, 'Комод 4 ящика Вишня светлая', '4033136', '41200.00', 6, 1),
(20, 'Тумба под ТВ', '4028048', '12350.00', 6, 4);

-- --------------------------------------------------------

--
-- Структура таблицы `product_categories`
--

CREATE TABLE `product_categories` (
  `category_id` int(11) NOT NULL,
  `category_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category_coefficient` decimal(3,1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `product_categories`
--

INSERT INTO `product_categories` (`category_id`, `category_name`, `category_coefficient`) VALUES
(1, 'Гостиные', '3.5'),
(2, 'Прихожие', '5.6'),
(3, 'Мягкая мебель', '3.0'),
(4, 'Кровати', '4.7'),
(5, 'Шкафы', '1.5'),
(6, 'Комоды', '2.3');

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `product_cost_analysis`
-- (См. Ниже фактическое представление)
--
CREATE TABLE `product_cost_analysis` (
`product_id` int(11)
,`product_name` varchar(150)
,`category_name` varchar(50)
,`material_name` varchar(100)
,`min_partner_price` decimal(10,2)
,`category_coefficient` decimal(3,1)
,`loss_percentage` decimal(5,4)
,`estimated_base_cost` decimal(14,2)
,`production_steps_count` bigint(21)
,`total_production_hours` decimal(26,1)
);

-- --------------------------------------------------------

--
-- Структура таблицы `request_products`
--

CREATE TABLE `request_products` (
  `request_product_id` int(11) NOT NULL,
  `request_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `calculated_cost` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `workshops`
--

CREATE TABLE `workshops` (
  `workshop_id` int(11) NOT NULL,
  `workshop_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `workshop_type_id` int(11) NOT NULL,
  `employee_count` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `workshops`
--

INSERT INTO `workshops` (`workshop_id`, `workshop_name`, `workshop_type_id`, `employee_count`) VALUES
(1, 'Проектный', 1, 4),
(2, 'Расчетный', 1, 5),
(3, 'Раскроя', 2, 5),
(4, 'Обработки', 2, 6),
(5, 'Сушильный', 3, 3),
(6, 'Покраски', 2, 5),
(7, 'Столярный', 2, 7),
(8, 'Изготовления изделий из искусственного камня и композитных материалов', 2, 3),
(9, 'Изготовления мягкой мебели', 2, 5),
(10, 'Монтажа стеклянных, зеркальных вставок и других изделий', 4, 2),
(11, 'Сборки', 4, 6),
(12, 'Упаковки', 4, 4);

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `workshop_load`
-- (См. Ниже фактическое представление)
--
CREATE TABLE `workshop_load` (
`workshop_id` int(11)
,`workshop_name` varchar(100)
,`workshop_type` varchar(50)
,`employee_count` int(11)
,`products_count` bigint(21)
,`total_hours` decimal(26,1)
,`hours_per_employee` decimal(28,2)
);

-- --------------------------------------------------------

--
-- Структура таблицы `workshop_types`
--

CREATE TABLE `workshop_types` (
  `workshop_type_id` int(11) NOT NULL,
  `type_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `workshop_types`
--

INSERT INTO `workshop_types` (`workshop_type_id`, `type_name`) VALUES
(1, 'Проектирование'),
(2, 'Обработка'),
(3, 'Сушка'),
(4, 'Сборка');

-- --------------------------------------------------------

--
-- Структура для представления `product_cost_analysis`
--
DROP TABLE IF EXISTS `product_cost_analysis`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `product_cost_analysis`  AS SELECT `p`.`product_id` AS `product_id`, `p`.`product_name` AS `product_name`, `pc`.`category_name` AS `category_name`, `mt`.`material_name` AS `material_name`, `p`.`min_partner_price` AS `min_partner_price`, `pc`.`category_coefficient` AS `category_coefficient`, `mt`.`loss_percentage` AS `loss_percentage`, round(((`p`.`min_partner_price` * (1 - `mt`.`loss_percentage`)) / `pc`.`category_coefficient`),2) AS `estimated_base_cost`, count(`ps`.`workshop_id`) AS `production_steps_count`, sum(`ps`.`production_time_hours`) AS `total_production_hours` FROM (((`products` `p` join `product_categories` `pc` on((`p`.`category_id` = `pc`.`category_id`))) join `material_types` `mt` on((`p`.`main_material_id` = `mt`.`material_type_id`))) left join `production_steps` `ps` on((`p`.`product_id` = `ps`.`product_id`))) GROUP BY `p`.`product_id`, `p`.`product_name`, `pc`.`category_name`, `mt`.`material_name`, `p`.`min_partner_price`, `pc`.`category_coefficient`, `mt`.`loss_percentage` ORDER BY `estimated_base_cost` AS `DESCdesc` ASC  ;

-- --------------------------------------------------------

--
-- Структура для представления `workshop_load`
--
DROP TABLE IF EXISTS `workshop_load`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `workshop_load`  AS SELECT `w`.`workshop_id` AS `workshop_id`, `w`.`workshop_name` AS `workshop_name`, `wt`.`type_name` AS `workshop_type`, `w`.`employee_count` AS `employee_count`, count(`ps`.`product_id`) AS `products_count`, sum(`ps`.`production_time_hours`) AS `total_hours`, round((sum(`ps`.`production_time_hours`) / `w`.`employee_count`),2) AS `hours_per_employee` FROM ((`workshops` `w` join `workshop_types` `wt` on((`w`.`workshop_type_id` = `wt`.`workshop_type_id`))) left join `production_steps` `ps` on((`w`.`workshop_id` = `ps`.`workshop_id`))) GROUP BY `w`.`workshop_id`, `w`.`workshop_name`, `wt`.`type_name`, `w`.`employee_count` ORDER BY `total_hours` AS `DESCdesc` ASC  ;

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `material_types`
--
ALTER TABLE `material_types`
  ADD PRIMARY KEY (`material_type_id`);

--
-- Индексы таблицы `partner_requests`
--
ALTER TABLE `partner_requests`
  ADD PRIMARY KEY (`request_id`);

--
-- Индексы таблицы `production_steps`
--
ALTER TABLE `production_steps`
  ADD PRIMARY KEY (`production_step_id`),
  ADD UNIQUE KEY `product_id` (`product_id`,`workshop_id`),
  ADD KEY `idx_production_product` (`product_id`),
  ADD KEY `idx_production_workshop` (`workshop_id`);

--
-- Индексы таблицы `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`),
  ADD KEY `idx_product_category` (`category_id`),
  ADD KEY `idx_product_material` (`main_material_id`);

--
-- Индексы таблицы `product_categories`
--
ALTER TABLE `product_categories`
  ADD PRIMARY KEY (`category_id`);

--
-- Индексы таблицы `request_products`
--
ALTER TABLE `request_products`
  ADD PRIMARY KEY (`request_product_id`),
  ADD KEY `request_id` (`request_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Индексы таблицы `workshops`
--
ALTER TABLE `workshops`
  ADD PRIMARY KEY (`workshop_id`),
  ADD KEY `workshop_type_id` (`workshop_type_id`);

--
-- Индексы таблицы `workshop_types`
--
ALTER TABLE `workshop_types`
  ADD PRIMARY KEY (`workshop_type_id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `material_types`
--
ALTER TABLE `material_types`
  MODIFY `material_type_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `partner_requests`
--
ALTER TABLE `partner_requests`
  MODIFY `request_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `production_steps`
--
ALTER TABLE `production_steps`
  MODIFY `production_step_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=136;

--
-- AUTO_INCREMENT для таблицы `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT для таблицы `product_categories`
--
ALTER TABLE `product_categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT для таблицы `request_products`
--
ALTER TABLE `request_products`
  MODIFY `request_product_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `workshops`
--
ALTER TABLE `workshops`
  MODIFY `workshop_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT для таблицы `workshop_types`
--
ALTER TABLE `workshop_types`
  MODIFY `workshop_type_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `production_steps`
--
ALTER TABLE `production_steps`
  ADD CONSTRAINT `production_steps_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`),
  ADD CONSTRAINT `production_steps_ibfk_2` FOREIGN KEY (`workshop_id`) REFERENCES `workshops` (`workshop_id`);

--
-- Ограничения внешнего ключа таблицы `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `product_categories` (`category_id`),
  ADD CONSTRAINT `products_ibfk_2` FOREIGN KEY (`main_material_id`) REFERENCES `material_types` (`material_type_id`);

--
-- Ограничения внешнего ключа таблицы `request_products`
--
ALTER TABLE `request_products`
  ADD CONSTRAINT `request_products_ibfk_1` FOREIGN KEY (`request_id`) REFERENCES `partner_requests` (`request_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `request_products_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`);

--
-- Ограничения внешнего ключа таблицы `workshops`
--
ALTER TABLE `workshops`
  ADD CONSTRAINT `workshops_ibfk_1` FOREIGN KEY (`workshop_type_id`) REFERENCES `workshop_types` (`workshop_type_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
