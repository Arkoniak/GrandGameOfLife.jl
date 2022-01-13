module GrandGameOfLife

using Random

export LifeCells, makestep, create_initial_state

struct Cell
    x::Int32
    y::Int32
end

Base.:(+)(c::Cell, d::Tuple) = Cell(c.x + d[1], c.y + d[2])

struct LifeCells
    bag::Set{Cell}
    bag2::Set{Cell}
end

LifeCells(v) = LifeCells(Set(v), Set(v))

has(L::LifeCells, c::Cell) = c in L.bag

# These are only needed for debugging purposes
# function to_xy(c::UInt64)
#     (c >> 32) % Int, (c & 0x00000000ffffffff) % Int
# end

# function to_cell(x::Int, y::Int)
#     return (x << 32 | y) % UInt64
# end

# function to_cell(x::Tuple{Int, Int})
#     return to_cell(x[1], x[2])
# end

struct Neighbourhood 
    c::Cell
end

function Base.iterate(iter::Neighbourhood, state = 1)
    if state == 1
        return (iter.c + (-1, -1), 2)
    elseif state == 2
        return (iter.c + (-1, 0), 3)
    elseif state == 3
        return (iter.c + (-1, 1), 4)
    elseif state == 4
        return (iter.c + (0, -1), 5)
    elseif state == 5
        return (iter.c + (0, 1), 6)
    elseif state == 6
        return (iter.c + (1, -1), 7)
    elseif state == 7
        return (iter.c + (1, 0), 8)
    elseif state == 8
        return (iter.c + (1, 1), 9)
    else
        return nothing
    end
end

# function neighbours!(neighbours_container, big_neighbourhood_container, L::LifeCells)
#     idx = 0
#     for coord in big_neighbourhood_container
#         if coord in L.bag
#             idx += 1
#             neighbours_container.v[idx] = coord
#         end
#     end
#     neighbours_container.l = idx
#     neighbours_container
# end
#
# function is_in_neighbours(neighbours_container, cell)
#     for i in 1:neighbours_container.l
#         neighbours_container.v[i] == cell && return 1
#     end
#     return 0
# end

function makestep(L::LifeCells)
    # initialize bag with the original size
    bag = L.bag2
    empty!(bag)
    sizehint!(bag, length(L.bag))

    for cell in L.bag
        cnt = 0
        for c in Neighbourhood(cell)
            k = has(L, c)
            cnt += k
            k && continue
            c in bag && continue

            cnt2 = 0
            for c2 in Neighbourhood(c)
                cnt2 += has(L, c2)
            end
            if cnt2 == 3
                push!(bag, c)
            end
        end
        if (cnt == 2) | (cnt == 3)
            push!(bag, cell)
        end
    end

    return LifeCells(bag, L.bag)
end

function create_initial_state(n, m, density = 0.7, rng = Random.GLOBAL_RNG)
    bag = Set{Cell}()
    sizehint!(bag, Int(ceil(n*m*density)))
    for i in 1:n, j in 1:m
        if rand(rng) <= density
            push!(bag, Cell(i, j))
        end
    end

    LifeCells(bag)
end

end # module
