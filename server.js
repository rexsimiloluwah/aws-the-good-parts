const { hostname } = require("os")
const http = require("http")

const PORT = process.env.PORT || 8080 
const server = http.createServer((_, res) => {
    res.statusCode = 200;
    res.setHeader("Content-Type", "text/html")
    console.log("Returning message..")
    res.end("<h1>Hello World, I am Similoluwa Okunowo</h1>")
})

server.listen(PORT, hostname, () => {
    console.log(`Server running at http://localhost:${PORT}/`)
})