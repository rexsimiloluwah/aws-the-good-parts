const { hostname } = require("os")
const http = require("http")

const PORT = process.env.PORT || 8080 

message = "<h1>Hello World. From Similoluwa Okunowo</h1>"
const server = http.createServer((_, res) => {
    res.statusCode = 200;
    res.setHeader("Content-Type", "text/html")
    console.log("Returning message..")
    res.end(message)
})

server.listen(PORT, hostname, () => {
    console.log(`Server running at http://localhost:${PORT}/`)
})