exports.handler = (event, context, callback) => {
    const request = event.Records[0].cf.request;

    const logObj = {
        path: request.uri,
        method: request.method,
        querystring: request.querystring,
    };

    console.log("Origin request", logObj);

    if (request.uri.endsWith('/')) {
        request.uri += 'index.html';
    } 
    else if (!request.uri.includes('.')) {
        request.uri += '/index.html';
    }

    callback(null, request);
}
