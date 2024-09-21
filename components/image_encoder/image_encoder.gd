class_name ImageEncoder extends Node


@onready var image_creator: ImageCreator = $ImageCreator


func _ready() -> void:
	var level_info: LevelInfo = load("res://saved_levels/New Map Level.tres")
	if level_info != null:
		var path = "user://" + level_info.level_name.to_snake_case() + ".png"
		print(path)
		var readable = level_info.level_name
		var level_name = create_text_chunk("level_name", readable.to_utf8_buffer())
		var image_data = create_text_chunk("image_data", level_info.level_graphic.save_png_to_buffer())
		var tilemap = create_text_chunk("tilemap_data", level_info.tilemap_data)
		save_data_to_png(path, readable, level_name, image_data, tilemap)


func load_data() -> void:
	var level_name = extract_text_chunk_from_png("user://My New Level.png", "level_name").get_string_from_utf8()
	var image_data = extract_text_chunk_from_png("user://My New Level.png", "image_data")
	var tilemap_data = extract_text_chunk_from_png("user://My New Level.png", "tilemap_data")


func save_data_to_png(
		output_path: String,
		level_readable_name: String,
		level_name: PackedByteArray,
		image_data: PackedByteArray,
		tilemap_data: PackedByteArray
		) -> void:
	var image = await image_creator.generate_image(level_readable_name)
	var png_data = image.save_png_to_buffer()
	#var text_chunk = create_text_chunk(key, bytes)
	
	# Insert the `tEXt` Chunk After the PNG Header (first 8 bytes)
	var png_header = png_data.slice(0, 8)  # PNG header is the first 8 bytes
	var data_chunks = level_name + image_data + tilemap_data
	var rest_of_png = png_data.slice(8, png_data.size() - 8)
	
	# Combine the header, new chunk, and the rest of the PNG data
	var modified_png_data = png_header + data_chunks + rest_of_png
	var output_file = FileAccess.open(output_path, FileAccess.WRITE)
	
	if not output_file:
		print("Failed to create output file.")
		return

	output_file.store_buffer(modified_png_data)
	output_file.close()
	print("PNG with custom tEXt chunk saved successfully to: ", output_path)


func create_text_chunk(key: String, data_bytes: PackedByteArray) -> PackedByteArray:
	# Combine the key and the data bytes
	var chunk_data = key.to_utf8_buffer() + "=".to_utf8_buffer() + data_bytes
	var chunk_type = "tEXt".to_utf8_buffer()
	var chunk_length = encode_uint32(chunk_data.size())
	var crc_input = chunk_type + chunk_data
	var chunk_crc = encode_uint32(CRC32.crc32(crc_input))

	# Combine length, type, data, and CRC to form the complete chunk
	var text_chunk = chunk_length + chunk_type + chunk_data + chunk_crc
	return text_chunk


func extract_text_chunk_from_png(file_path: String, key: String) -> PackedByteArray:
	# Step 1: Read the PNG File as Binary Data
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		print("Failed to open file.")
		return PackedByteArray()

	# Read all bytes from the file
	var png_data = file.get_buffer(file.get_length())
	file.close()

	var index = 8  # Skip the first 8 bytes (PNG header)
	while index < png_data.size():
		var chunk_length = decode_uint32(png_data.slice(index, index + 4))
		var chunk_type = png_data.slice(index + 4, index + 8)
		var chunk_data = png_data.slice(index + 8, index + 8 + chunk_length)
		var chunk_crc = decode_uint32(png_data.slice(index + 8 + chunk_length, index + 8 + chunk_length + 4))
	   # Debugging Information
		print("Chunk Type: ", chunk_type.get_string_from_utf8())
		print("Chunk Length: ", chunk_length)
		print("Chunk Data Size: ", chunk_data.size())
		print("Chunk CRC: ", chunk_crc)

		# Check if the chunk is a `tEXt` chunk
		if chunk_type == "tEXt".to_utf8_buffer():
			var text_data_str = chunk_data.get_string_from_utf8()

			# Step 3: Check if the `tEXt` Chunk Contains the Desired Key
			if text_data_str.begins_with(key + "="):
				# Extract the byte data after 'key='
				var key_length = key.to_utf8_buffer().size() + 1  # +1 for '=' separator
				if chunk_data.size() > key_length:
					print(key_length)
					var value_bytes = chunk_data.slice(key_length, chunk_data.size())
					
					print("Extracted Bytes Size: ", value_bytes.size())
					return value_bytes  # Return the extracted obfuscated data as PackedByteArray

		# Move to the next chunk: 4 (length) + 4 (type) + chunk_length (data) + 4 (CRC)
		index += 8 + chunk_length + 4

	# No `tEXt` chunk with the specified key was found
	print("No `tEXt` chunk with key '", key, "' found.")
	return PackedByteArray()


func encode_uint32(value: int) -> PackedByteArray:
	var arr = PackedByteArray()
	arr.resize(4)
	arr[0] = (value >> 24) & 0xFF
	arr[1] = (value >> 16) & 0xFF
	arr[2] = (value >> 8) & 0xFF
	arr[3] = value & 0xFF
	return arr


func decode_uint32(data: PackedByteArray) -> int:
	if data.size() < 4:
		return 0
	return (data[0] << 24) | (data[1] << 16) | (data[2] << 8) | data[3]


class CRC32:
	static func crc32(data: PackedByteArray) -> int:
		var crc = 0xFFFFFFFF
		for byte in data:
			crc ^= byte
			for x in range(8):
				if crc & 1:
					crc = (crc >> 1) ^ 0xEDB88320
				else:
					crc >>= 1
		return crc ^ 0xFFFFFFFF
