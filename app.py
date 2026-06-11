from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
import httpx
import uvicorn
import asyncio

app = FastAPI()
INTERNAL_URL = "http://localhost:8080"
searxng_ready = False

@app.on_event("startup")
async def wait_for_searxng():
    global searxng_ready
    for i in range(30):
        try:
            async with httpx.AsyncClient(timeout=3.0) as client:
                r = await client.get(INTERNAL_URL)
                if r.status_code < 500:
                    searxng_ready = True
                    break
        except Exception:
            pass
        await asyncio.sleep(2)

@app.get("/")
async def root():
    return {"status": "ok", "ready": searxng_ready}

@app.get("/health")
async def health():
    return {"status": "healthy"}

@app.get("/search")
async def search(request: Request):
    params = dict(request.query_params)
    if "format" not in params:
        params["format"] = "json"

    if not searxng_ready:
        return JSONResponse({
            "query": params.get("q", ""),
            "number_of_results": 0,
            "results": [],
            "error": "Service starting"
        }, status_code=503)

    try:
        async with httpx.AsyncClient(timeout=30.0) as client:
            response = await client.get(
                f"{INTERNAL_URL}/search",
                params=params,
                headers={"Accept": "application/json"}
            )
        try:
            data = response.json()
            if "number_of_results" not in data:
                data["number_of_results"] = len(data.get("results", []))
            if "results" not in data:
                data["results"] = []
            if "query" not in data:
                data["query"] = params.get("q", "")
            return JSONResponse(content=data)
        except Exception:
            return JSONResponse({
                "query": params.get("q", ""),
                "number_of_results": 0,
                "results": [],
                "error": "Parse error"
            })
    except Exception as e:
        return JSONResponse({
            "query": params.get("q", ""),
            "number_of_results": 0,
            "results": [],
            "error": str(e)
        }, status_code=500)

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=10000)
