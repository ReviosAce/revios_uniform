CREATE TABLE uniforms (
  id int NOT NULL,
  identifier varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  oldskin longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  uniform varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE uniforms
  ADD PRIMARY KEY (id),
  ADD UNIQUE KEY id (id);

ALTER TABLE uniforms
  MODIFY id int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;