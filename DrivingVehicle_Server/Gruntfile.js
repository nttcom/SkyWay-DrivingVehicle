module.exports = function(grunt) {

    require('time-grunt')(grunt);
    require('load-grunt-tasks')(grunt);
    var pkg = grunt.file.readJSON( 'package.json' );

    grunt.initConfig({
        pkg: pkg,
        bower: {
            install: {
                options: {
                    targetDir: 'dev/bower_components',
                    layout: 'byComponent',
                    install: true,
                    verbose: false,
                    cleanTargetDir: true,
                    cleanBowerDir: true
                }
            }
        },
        tsd: {
            refresh: {
                options: {
                    command: 'reinstall',
                    latest: true,
                    config: 'dev/js/tsd.json',
                    overwrite: true,
                    opts: {
                    }
                }
            }
        },
        typescript: {
            default: {
                src: ['dev/js/**/*.ts','!dev/js/typings/**/*.ts'],
                dest: '',
                options: {
                    module: 'amd', //or commonjs
                    target: 'es5', //or es3
                    rootDir: 'dev',
                    sourceMap: false,
                }
            }
        },
        clean: {
            setup: ["dev/bower_components", "dev/js/typings"],
            build: ["dist/*"]
        },
        copy: {
            main:{
                files: [
                    {
                        expand: true,
                        cwd: 'dev/',
                        src: '*.html',
                        dest: 'dist/'

                    },
                    {
                        expand: true,
                        cwd: 'dev/img',
                        src: '**',
                        dest: 'dist/img/'
                    },
                    {
                        expand: true,
                        cwd: 'dev/bower_components/fontawesome/fonts',
                        src: '**',
                        dest: 'dist/fonts/'
                    }
                ]
            }
        },
        useminPrepare: {
            html: 'dev/*.html',
            options: {
                flow: {
                    steps: {
                        'js': ['concat'],
                        'css': ['concat']},
                    post: {}
                },
                dest: "dist"
            }
        },
        usemin: {
            html:['dist/*.html']
        }
    });

    Object.keys( pkg.devDependencies ).forEach( function( devDependency ) {
        if( devDependency.match( /^grunt\-/ ) ) {
            grunt.loadNpmTasks( devDependency );
        }
    } );

    grunt.registerTask('setup', ['clean:setup', 'bower:install', 'tsd']);
    grunt.registerTask('build', ['clean:build', 'typescript', 'copy', 'useminPrepare', 'concat', 'usemin']);
};

