package main

import "core:c"
import "core:fmt"
import gl "vendor:OpenGL"
import "vendor:glfw"

GL_MAJ, GL_MIN :: 3, 3
WIDTH, HEIGHT :: 1280, 800

vertices := [?]f32 {
	// top left [0]
	-0.5,
	0.5,
	0,

	// top right [3]
	0.5,
	0.5,
	0,

	// bottom right [6]
	0.5,
	-0.5,
	0,

	// bottom left [9]
	-0.5,
	-0.5,
	0,
}

main :: proc() {
	if glfw.Init() != glfw.TRUE {
		fmt.println("Failed to initialize GLFW")
		return
	}

	defer glfw.Terminate()

	// config window
	glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, GL_MAJ)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, GL_MIN)
	glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)

	window := glfw.CreateWindow(WIDTH, HEIGHT, "LearnOpenGL", nil, nil)
	defer glfw.DestroyWindow(window)

	if window == nil {
		fmt.println("Failed to create GLFW Window")
		return
	}

	glfw.MakeContextCurrent(window)
	glfw.SwapInterval(1)
	gl.load_up_to(GL_MAJ, GL_MIN, glfw.gl_set_proc_address)
	glfw.SetFramebufferSizeCallback(window, window_resized)
	gl.Viewport(0, 0, WIDTH, HEIGHT)

	// Create Vertex Buffer Object and fill it with our vertices
	VBO: u32
	gl.GenBuffers(1, &VBO)
	gl.BindBuffer(gl.ARRAY_BUFFER, VBO)
	gl.BufferData(gl.ARRAY_BUFFER, size_of(vertices), &vertices, gl.STATIC_DRAW)

	// Create and configure Vertex Array Object
	VAO: u32
	gl.GenVertexArrays(1, &VAO)
	gl.BindVertexArray(VAO)
	gl.VertexAttribPointer(0, 3, gl.FLOAT, gl.FALSE, 3 * size_of(f32), 0)
	gl.EnableVertexAttribArray(0)

	// Compile shaders
	shader_program, ok := gl.load_shaders("shaders/vert.glsl", "shaders/frag.glsl")
	if !ok {
		fmt.println("Failed to compile shaders")
		return
	}
	defer gl.DeleteProgram(shader_program)

	// game loop
	for !glfw.WindowShouldClose(window) {
		process_input(window)

		render(shader_program, VAO)

		glfw.SwapBuffers(window)
		glfw.PollEvents()
	}
}

window_resized :: proc "c" (window: glfw.WindowHandle, width, height: i32) {
	gl.Viewport(0, 0, width, height)
}

render :: proc(shader_program: u32, VAO: u32) {
	gl.ClearColor(0.1, 0.1, 0.1, 1)
	gl.Clear(gl.COLOR_BUFFER_BIT)

	gl.UseProgram(shader_program)

	// Use the VAO we configured earlier to draw VBO's first 3 vertices as a triangle
	// Note: we don't bind VBO here because it is the only
	gl.BindVertexArray(VAO)
	gl.DrawArrays(gl.TRIANGLES, 0, 3)
}

process_input :: proc(window: glfw.WindowHandle) {
	if glfw.GetKey(window, glfw.KEY_ESCAPE) == glfw.PRESS {
		glfw.SetWindowShouldClose(window, true)
	}
}
