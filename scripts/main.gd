
extends Node3D

func _ready():
    print("PREMIER LEAGUE 3D is starting!")

    create_environment()
    create_pitch()
    create_goals()
    create_ball()
    create_players()

func create_environment():
    var environment = WorldEnvironment.new()
    var env = Environment.new()

    env.background_mode = Environment.BG_SKY
    env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    env.ambient_light_color = Color(0.65, 0.72, 0.85)
    env.ambient_light_energy = 0.8

    environment.environment = env
    add_child(environment)

    var sunlight = DirectionalLight3D.new()
    sunlight.rotation_degrees = Vector3(-50, -30, 0)
    sunlight.light_energy = 1.2
    add_child(sunlight)

func create_pitch():
    var pitch = MeshInstance3D.new()
    var mesh = BoxMesh.new()

    mesh.size = Vector3(70, 0.2, 110)
    pitch.mesh = mesh

    var material = StandardMaterial3D.new()
    material.albedo_color = Color(0.08, 0.42, 0.12)
    pitch.material_override = material

    add_child(pitch)

func create_goals():
    for z in [-54.0, 54.0]:
        var goal = MeshInstance3D.new()
        var mesh = BoxMesh.new()

        mesh.size = Vector3(14, 5, 1)
        goal.mesh = mesh
        goal.position = Vector3(0, 2.5, z)

        var material = StandardMaterial3D.new()
        material.albedo_color = Color.WHITE
        goal.material_override = material

        add_child(goal)

func create_ball():
    var ball = MeshInstance3D.new()
    var mesh = SphereMesh.new()

    mesh.radius = 0.7
    mesh.height = 1.4
    ball.mesh = mesh
    ball.position = Vector3(0, 1, 0)

    var material = StandardMaterial3D.new()
    material.albedo_color = Color.WHITE
    ball.material_override = material

    add_child(ball)

func create_players():
    for team in range(2):
        for i in range(11):
            var player = MeshInstance3D.new()
            var mesh = CapsuleMesh.new()

            player.mesh = mesh

            var material = StandardMaterial3D.new()

            if team == 0:
                material.albedo_color = Color(0.8, 0.05, 0.05)
            else:
                material.albedo_color = Color(0.05, 0.1, 0.8)

            player.material_override = material

            var x = (i % 4) * 5.0 - 7.5
            var z = -40.0 + (i / 4) * 12.0

            if team == 1:
                z = -z

            player.position = Vector3(x, 1.0, z)
            add_child(player)
