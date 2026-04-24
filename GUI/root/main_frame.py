from tkinter import *
from window_menu import Window


HEIGHT = 700
WIDTH = 1000
BGCOLOUR = '#535353'
EDITORHEIGHT = 300
cursor_mouse_position = 100

def move_cursor(position: int):
    for i in range(cursor_mouse_position-3, cursor_mouse_position+3):
        if i == position:
            cursor_mouse_position = position



# create the tkinter object
root = Tk()
root.title("camera robot controller")
root.minsize(800, 600)

# creating a canvas to define height, width
canvas = Canvas(root, height=HEIGHT, width=WIDTH)
canvas.pack()


background = Window(root)
background.configure(background=BGCOLOUR)
background.place(relwidth=1, relheight=1)

menu_bar = Frame(background)
menu_bar.configure(background=BGCOLOUR)
menu_bar.place(anchor='n', x=0, y=0, height=30, relwidth=2, bordermode='inside')


editor = Frame(background)
editor.configure(background=BGCOLOUR)
editor.place(relx=0, rely=0.5, relheight=1, relwidth=1)

pitch_axis = Button(editor, text="Pitch Axis", bg=BGCOLOUR, activebackground=BGCOLOUR, activeforeground=BGCOLOUR)
pitch_axis.place(x=10, y=10)

y_axis = Button(editor, text="Yaw Axis  ", bg=BGCOLOUR, activebackground=BGCOLOUR, activeforeground=BGCOLOUR)
y_axis.place(x=10, y=40)


timeline = Canvas(
    editor, height=300, width=1000, scrollregion=(0, 0, 800, 0), bg=BGCOLOUR)
timeline.place(x=100, y=0, relwidth=0.9, relheight=0.5)


def get_timeline_mouse_position():
    root.winfo_rootx()


cursor = timeline.create_line(cursor_mouse_position, 0, cursor_mouse_position, 400)

timeline_scale = Scrollbar(editor, orient='horizontal')
timeline_scale.place(anchor='w', x=100, rely=0.49, relwidth=0.9)

timeline.yscrollcommand = timeline_scale.set

# run to periodically update the programme interface
root.mainloop()
root.after(2, move_cursor(get_timeline_mouse_position()))


