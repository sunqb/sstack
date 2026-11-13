# Java preset

把本目录文件复制进项目后，按构建工具合并示例，不要覆盖已有的 `pom.xml` 或 `build.gradle(.kts)`。

`scripts/verify.sh` 的行为：

- 有 `pom.xml` 时：优先 `./mvnw`，否则 `mvn`；跑 `test`（含编译）。若 POM 里配置了 Spotless 或 Checkstyle，再跑 `spotless:check` / `checkstyle:check`。
- 有 `build.gradle` 或 `build.gradle.kts` 时：优先 `./gradlew`，否则 `gradle`；跑 `test`。若配置了相应插件，再跑 `spotlessCheck` / `checkstyleMain`。
- 包装器与工具都不在时跳过，不失败。

文件说明：

- `checkstyle.xml`：Checkstyle 起步规则（可改路径后在插件里引用）。
- `spotless.maven.example.xml` / `spotless.gradle.example.kts`：合并进构建文件的片段。
- `examples/archunit/PackageBoundaryTest.java`：用 ArchUnit 把「某层不得依赖另一层」写成测试，适合 poteto flow 的纠正闭环。把它移到 `src/test/java`，并加上 ArchUnit 依赖后才会被执行。
