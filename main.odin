package main

import "core:c"
import "core:fmt"
import gl "vendor:OpenGL"
import "vendor:glfw"

GL_MAJ, GL_MIN :: 3, 3
WIDTH, HEIGHT :: 1280, 800

main :: proc() {
	if glfw.Init() != glfw.TRUE {
		fmt.println("Failed to initialize GLFW")
		return
	}

	defer glfw.Terminate()

	glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, GL_MAJ)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, GL_MIN)
	glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)
	//glfw.WindowHint(glfw.RESIZABLE, glfw.FALSE)

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

	for !glfw.WindowShouldClose(window) {
		process_input(window)

		render()

		glfw.SwapBuffers(window)
		glfw.PollEvents()
	}
}

window_resized :: proc "c" (window: glfw.WindowHandle, width, height: i32) {
	gl.Viewport(0, 0, width, height)
}

render :: proc() {
	gl.ClearColor(0.1, 0.1, 0.1, 1)
	gl.Clear(gl.COLOR_BUFFER_BIT)
}

process_input :: proc(window: glfw.WindowHandle) {
	if glfw.GetKey(window, glfw.KEY_ESCAPE) == glfw.PRESS {
		glfw.SetWindowShouldClose(window, true)
	}
}
