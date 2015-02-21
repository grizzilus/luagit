local trim = function(s)
  return s:match"^%s*(.*%S)" or ""
end

local check_if_git_repo = function()
  local f = io.popen("git rev-parse --is-inside-work-tree")
  local temp = f:read("*all")
  temp = trim(temp)
  if temp == "true" then
    return true
  end
  return false
end

local clean_lua_output = function(text)
  local temp = trim(text)
  temp = string.gsub(temp, "\n", "\\par")
  return temp
end

git_commit_hash = function(parameter)
  if check_if_git_repo() then
    local f = io.popen("git rev-parse " .. parameter)
    local temp = f:read("*all")
    return clean_lua_output(temp)
  else
    return "Not a git repository"
  end
end

CURRENT_HEAD = git_commit_hash("HEAD")

print_head = function(length)
  if length >= 40 or length < 0 then
    tex.sprint(CURRENT_HEAD)
  else
    local temp = string.sub(CURRENT_HEAD, 0, length)
    tex.sprint(temp)
  end
end

git_status = function()
  if check_if_git_repo() then
    local f = io.popen("git status -s")
    local temp = f:read("*all")
    return clean_lua_output(temp)
  else
    return "Not a git repository"
  end
end
