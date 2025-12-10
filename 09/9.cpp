#include <iostream>
#include <vector>
#include <optional>

#include <cfloat>

#include <raylib.h>
#include <raymath.h>

typedef std::pair<long, long> Point;

static long
area(Point a, Point b)
{
  return (1 + std::max(a.first, b.first) - std::min(a.first, b.first))
    * (1 + std::max(a.second, b.second) - std::min(a.second, b.second));
}

static inline Vector2
point_to_vector2(Point p) {
  return (Vector2){0.f+p.first,  0.f+p.second};
}

static size_t
nearest(Point p, std::vector<Point>& pts)
{
  size_t res = 0;
  float dist = FLT_MAX;
  size_t i;
  for (i = 0; i < pts.size(); ++i) {
    auto pt = pts[i];
    auto cur = Vector2Distance(point_to_vector2(p), point_to_vector2(pt));
    if (cur < dist)
      dist = cur, res = i;
  }

  return res;
}

static Point
GetMousePositionP()
{
  Vector2 p = GetMousePosition();
  return Point(p.x, p.y);
}


static void
p2(std::vector<Point> &pts_)
{
  std::vector<Point> pts;
  long maxx = 0, maxy = 0;
  for (auto p : pts_) maxx = std::max(maxx, p.first), maxy = std::max(maxy, p.second);
  for (auto p : pts_)
    pts.push_back(Point(Remap(p.first,  0, maxx, 0, 1920),
                        Remap(p.second, 0, maxy, 0, 1200)));
  SetTargetFPS(60);
  InitWindow(1920, 1200, "gah");

  std::optional<int> click = std::nullopt;
  while (!WindowShouldClose()) {
    auto nr = nearest(GetMousePositionP(), pts);
    if (IsMouseButtonDown(MOUSE_BUTTON_LEFT))
      click = click == std::nullopt ? nearest(GetMousePositionP(), pts) : click;
    else
      click = std::nullopt;
    BeginDrawing();
    {
      ClearBackground(BLACK);
      std::optional<Point> last = std::nullopt;
      for (auto p : pts) {
        if (last != std::nullopt)
          DrawLineEx(point_to_vector2(p), point_to_vector2(last.value()), 2, RED);
        if ((click != std::nullopt && pts[click.value()] == p) || p == pts[nr])
          DrawCircleV(point_to_vector2(p), 10, ORANGE);
        else
          DrawCircleV(point_to_vector2(p), 3, GREEN);
        last = p;
      }
      if (click != std::nullopt) {
        auto a = pts_[click.value()], b = pts_[nr];
        auto as = pts[click.value()], bs = pts[nr];
        auto sz = area(a, b);
        DrawText(TextFormat("%ld", area), 0, 0, 16, WHITE);
        if (IsKeyPressed(KEY_SPACE))
          std::cout << sz << std::endl;
        DrawRectangleLines(std::min(as.first, bs.first),
                           std::min(as.second, bs.second),
                           std::abs(as.first-bs.first),
                           std::abs(as.second-bs.second),
                           RED);
      }
      DrawLineEx(point_to_vector2(pts[0]), point_to_vector2(last.value()), 2, RED);
    }
    EndDrawing();
  }
}

int
main(void)
{
  std::FILE *fp = std::fopen("input", "r");
  std::vector<Point> pts;
  while (!std::feof(fp)) {
    long a, b;
    std::fscanf(fp, "%ld,%ld\n", &a, &b);
    pts.push_back(Point(a, b));
  }

  long max = 0;
  for (size_t i = 0; i < pts.size(); ++i)
    for (size_t j = i; j < pts.size(); ++j)
      max = std::max(max, area(pts[i], pts[j]));
  std::printf("p1: %ld\n", max);

  p2(pts);

  return 0;
}

// Local Variables:
// compile-command: "clang++-19 -std=c++17 -Wall -Wextra -o 9 9.cpp -lraylib && ./9"
// End:
