local toolbar = import '../../Components/Toolbar.libsonnet';

{
  lightToolbar: toolbar.newToolbar(false),
  darkToolbar: toolbar.newToolbar(true),
}
