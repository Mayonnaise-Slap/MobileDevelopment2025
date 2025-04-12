import feedparser
from rest_framework.response import Response
from rest_framework.views import APIView

class Index(APIView):
    def get(self, request):
        url = 'https://news.ycombinator.com/rss'
        try:
            feed_data = feedparser.parse(url)

            feed_json = {
                "title": feed_data.feed.get("title"),
                "link": feed_data.feed.get("link"),
                "description": feed_data.feed.get("description"),
                "items": [
                    {
                        "title": entry.get("title"),
                        "link": entry.get("link"),
                        "published": entry.get("published"),
                        "summary": entry.get("summary"),
                    }
                    for entry in feed_data.entries
                ]
            }

            return Response(feed_json)

        except Exception as e:
            return Response({"error": str(e)}, status=500)
