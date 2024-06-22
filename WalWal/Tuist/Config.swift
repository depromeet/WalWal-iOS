import ProjectDescription

let config = Config(
    plugins: [
        .local(path: .relativeToManifest("../../Plugins/DependenciesPlugin")),
        .local(path: .relativeToManifest("../../Plugins/TemplatesPlugin"))
    ]
)
