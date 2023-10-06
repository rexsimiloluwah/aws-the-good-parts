const { hostname } = require("os")
const http = require("http")

const PORT = process.env.PORT || 8080 
const STACK_NAME = process.env.STACK_NAME || "Unknown Stack"

message = `<h1>Hello, My people. From ${hostname()}</h1> <p>From stack ${STACK_NAME}`

const server = http.createServer((_, res) => {
    res.statusCode = 200;
    res.setHeader("Content-Type", "text/html")
    console.log("Returning message..")
    res.end(message)
})

server.listen(PORT, hostname, () => {
    console.log(`Server running at http://${hostname()}:${PORT}/`)
})