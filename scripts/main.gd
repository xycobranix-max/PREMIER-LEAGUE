
extends Node3D

const PITCH_LENGTH = 110.0
const PITCH_WIDTH = 70.0

func _ready():
    create_environment()
    create_pitch()
    create_pitch_markings()
    create_goals()
    create_ball()
    create_players()
    create_camera()
    create_stadium_lights()

    print("PREMIER LEAGUE 3D loaded!")

func create_environment():
    var world = WorldEnvironment.new()
    var env = Environment.new()

    env.background_mode = Environment.BG_COLOR
    env.background_color = Color(0.025, 0.04, 0.08)
    env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    env.ambient_light_color = Color(0.7, 0.75, 0.85)
    env.ambient_light_energy = 0.8

    world.environment = env
    add_child(world)

func create_material(color: Color):
    var material = StandardMaterial3D.new()
    material.albedo_color = color
    return material

func create_box(size: Vector3, position: Vector3, color: Color):
    var item = MeshInstance3D.new()
    var mesh = BoxMesh.new()

    mesh.size = size
    item.mesh = mesh
    item.position = position
    item.material_override = create_material(color)

    add_child(item)
    return item

func create_pitch():
    create_box(
        Vector3(PITCH_WIDTH, 0.2, PITCH_LENGTH),
        Vector3(0, 0, 0),
        Color(0.06, 0.35, 0.09)
    )

    # Alternating grass strips
    for i in range(10):
        var z = -49.5 + i * 11.0

        var color = Color(0.08, 0.42, 0.12)
        if i % 2 == 0:
            color = Color(0.06, 0.34, 0.09)

        create_box(
            Vector3(PITCH_WIDTH, 0.03, 11.0),
            Vector3(0, 0.115, z),
            color
        )

func create_pitch_markings():
    var white = Color.WHITE

    # Outer boundary
    create_box(Vector3(0.18, 0.04, 110), Vector3(-35, 0.14, 0), white)
    create_box(Vector3(0.18, 0.04, 110), Vector3(35, 0.14, 0), white)
    create_box(Vector3(70, 0.04, 0.18), Vector3(0, 0.14, -55), white)
    create_box(Vector3(70, 0.04, 0.18), Vector3(0, 0.14, 55), white)

    # Halfway line
    create_box(Vector3(70, 0.04, 0.18), Vector3(0, 0.15, 0), white)

    # Centre circle
    var circle = MeshInstance3D.new()
    var ring = TorusMesh.new()

    ring.inner_radius = 9.0
    ring.outer_radius = 9.2

    circle.mesh = ring
    circle.position = Vector3(0, 0.16, 0)
    circle.material_override = create_material(white)
    add_child(circle)

    # Penalty areas
    for side in [-1, 1]:
        var z = side * 44.0

        create_box(Vector3(42, 0.04, 0.18), Vector3(0, 0.15, z), white)
        create_box(Vector3(0.18, 0.04, 22), Vector3(-21, 0.15, side * 44), white)
        create_box(Vector3(0.18, 0.04, 22), Vector3(21, 0.15, side * 44), white)

func create_goals():
    for side in [-1, 1]:
        var z = side * 55.0
        var post_color = Color.WHITE

        # Goal posts and crossbar
        create_box(Vector3(0.4, 5, 0.4), Vector3(-3.7, 2.5, z), post_color)
        create_box(Vector3(0.4, 5, 0.4), Vector3(3.7, 2.5, z), post_color)
        create_box(Vector3(7.8, 0.4, 0.4), Vector3(0, 5, z), post_color)

func create_ball():
    var ball = MeshInstance3D.new()
    var sphere = SphereMesh.new()

    sphere.radius = 0.7
    sphere.height = 1.4

    ball.mesh = sphere
    ball.position = Vector3(0, 1, 0)
    ball.material_override = create_material(Color.WHITE)

    add_child(ball)

func create_players():
    for team in range(2):
        for i in range(11):
            var player = MeshInstance3D.new()
            var capsule = CapsuleMesh.new()

            capsule.radius = 0.65
            capsule.height = 2.0

            player.mesh = capsule

            if team == 0:
                player.material_override = create_material(Color(0.8, 0.03, 0.04))
            else:
                player.material_override = create_material(Color(0.03, 0.12, 0.85))

            var x = float(i % 4) * 5.0 - 7.5
            var z = -40.0 + float(i / 4) * 12.0

            if team == 1:
                z = -z

            player.position = Vector3(x, 1.15, z)
            add_child(player)

func create_camera():
    var camera = Camera3D.new()

    camera.position = Vector3(0, 65, 88)
    camera.look_at(Vector3(0, 0, 0), Vector3.UP)
    camera.fov = 55

    add_child(camera)
    camera.current = true

func create_stadium_lights():
    for x in [-42.0, 42.0]:
        for z in [-50.0, 50.0]:
            var light = OmniLight3D.new()

            light.position = Vector3(x, 22, z)
            light.light_energy = 2.0
            light.omni_range = 65

            add_child(light)
