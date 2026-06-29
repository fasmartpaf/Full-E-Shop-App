#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <sys/io.h>
#include <cstdlib>

#ifdef GDK_WINDOWING_X11
#include <gdk/gdkx.h>
#endif

#include "flutter/generated_plugin_registrant.h"

// This signal handler is the same as the one in the Flutter engine's
// backend window implementation, and is thus at the lowest level.
static gboolean on_key_press_event(GtkWidget* widget, GdkEventKey* event,
                                    gpointer userdata) {
  if (event->state & GDK_CONTROL_MASK && event->keyval == GDK_KEY_q) {
    gtk_main_quit();
    return TRUE;
  }
  return FALSE;
}

int main(int argc, char* argv[]) {
  g_set_application_name("testing_app_brief");

  gtk_init(&argc, &argv);

  GtkWindow* window =
      GTK_WINDOW(gtk_application_window_new(nullptr));

  gtk_window_set_default_size(window, 1280, 720);
  gtk_window_set_title(window, "testing_app_brief");

  g_signal_connect(window, "key-press-event", G_CALLBACK(on_key_press_event), nullptr);
  g_signal_connect(window, "destroy", G_CALLBACK(gtk_main_quit), nullptr);

  g_autoptr(FlDartProject) project = fl_dart_project_new();
  fl_dart_project_set_dart_entrypoint_arguments(project, nullptr);

  g_autoptr(FlView) view = fl_view_new(project);
  gtk_widget_set_vexpand(GTK_WIDGET(view), TRUE);
  gtk_widget_set_hexpand(GTK_WIDGET(view), TRUE);
  gtk_container_add(GTK_CONTAINER(window), GTK_WIDGET(view));

  fl_register_plugins(FL_PLUGIN_REGISTRY(view));

  gtk_widget_grab_focus(GTK_WIDGET(view));
  gtk_widget_show(GTK_WIDGET(window));

  gtk_main();

  return EXIT_SUCCESS;
}
