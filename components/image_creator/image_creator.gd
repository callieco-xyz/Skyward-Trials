class_name ImageCreator extends Node


@onready var view: SubViewport = $ImageViewport
@onready var comp: Composition = $ImageViewport/Composition


func generate_image(new_title: String) -> Image:
	comp.set_level_name(new_title)
	await RenderingServer.frame_post_draw
	var new_image = comp.get_viewport().get_texture().get_image()
	return new_image
