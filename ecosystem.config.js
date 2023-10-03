module.exports = {
    apps: [
        {
            name: "sample_aws_web_app",
            script: "server.js", // entry point file
            instances: 1,
            autorestart: true,
            watch: false,
            max_memory_restart: "1G",
            env: {
                NODE_ENV: "production"
            },
            error_file: "./logs/error.log",
            out_file: "./logs/output.log"
        }
    ]
}