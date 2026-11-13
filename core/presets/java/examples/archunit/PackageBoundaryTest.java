package com.example.architecture;

import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.noClasses;

import com.tngtech.archunit.core.importer.ImportOption;
import com.tngtech.archunit.junit.AnalyzeClasses;
import com.tngtech.archunit.junit.ArchTest;
import com.tngtech.archunit.lang.ArchRule;

/**
 * Example: encode an import boundary as a test (poteto-style correction loop).
 * Move this into src/test/java and add the archunit-junit5 dependency before it will run.
 * Adjust package names to your layout.
 */
@AnalyzeClasses(packages = "com.example", importOptions = ImportOption.DoNotIncludeTests.class)
class PackageBoundaryTest {

    @ArchTest
    static final ArchRule appMustNotDependOnInfra =
            noClasses()
                    .that()
                    .resideInAPackage("com.example.app..")
                    .should()
                    .dependOnClassesThat()
                    .resideInAPackage("com.example.infra..")
                    .because("app/ must not import infra/ directly; go through a port in domain/");
}
