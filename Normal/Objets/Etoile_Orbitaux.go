components {
  id: "Etoile_Orbitaux"
  component: "/Normal/Scripts/Etoile_Orbitaux.script"
}
embedded_components {
  id: "collisionobject"
  type: "collisionobject"
  data: "type: COLLISION_OBJECT_TYPE_TRIGGER\n"
  "mass: 0.0\n"
  "friction: 0.1\n"
  "restitution: 0.5\n"
  "group: \"default\"\n"
  "mask: \"default\"\n"
  "embedded_collision_shape {\n"
  "  shapes {\n"
  "    shape_type: TYPE_SPHERE\n"
  "    position {\n"
  "    }\n"
  "    rotation {\n"
  "    }\n"
  "    index: 0\n"
  "    count: 1\n"
  "  }\n"
  "  data: 10.0\n"
  "}\n"
  ""
}
embedded_components {
  id: "Orbital_sprite"
  type: "sprite"
  data: "default_animation: \"planet_default\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/Normal/Atlas/Systeme.atlas\"\n"
  "}\n"
  ""
}
