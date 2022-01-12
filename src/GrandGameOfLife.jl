module GrandGameOfLife

export LifeCells, to_cell, to_xy, makestep, has, create_initial_state

struct Cell
    x::Int32
    y::Int32
end

struct LifeCells
    bag::Set{UInt64}
end

LifeCells(v::Vector) = LifeCells(Set(v))

has(L::LifeCells, c::UInt64) = c in L.bag

struct ContainerWithLength{T}
    v::Vector{T}
    l::Int
end

ContainerWithLength{T}(init_size) where T = ContainerWithLength(Vector{T}(undef, init_size), 0)

# These are only needed for debugging purposes
function to_xy(c::UInt64)
    (c >> 32) % Int, (c & 0x00000000ffffffff) % Int
end

function to_cell(x::Int, y::Int)
    return (x << 32 | y) % UInt64
end

function to_cell(x::Tuple{Int, Int})
    return to_cell(x[1], x[2])
end

function neighbourhood!(neighbourhood_container, c::UInt64)
    neighbourhood_container[1] = (((c >> 32) - 1) << 32) | (c & 0x00000000ffffffff)
    neighbourhood_container[2] = (((c >> 32) + 1) << 32) | (c & 0x00000000ffffffff)
    neighbourhood_container[3] = c + 1
    neighbourhood_container[4] = (c & 0xffffffff00000000) | ((c & 0x00000000ffffffff) - 1)
    neighbourhood_container[5] = (((c >> 32) - 1) << 32) | ((c & 0x00000000ffffffff) - 1)
    neighbourhood_container[6] = (((c >> 32) - 1) << 32) | ((c & 0x00000000ffffffff) + 1)
    neighbourhood_container[7] = (((c >> 32) + 1) << 32) | ((c & 0x00000000ffffffff) - 1)
    neighbourhood_container[8] = (((c >> 32) + 1) << 32) | ((c & 0x00000000ffffffff) + 1)
end

# function bigneighbourhood!(big_neighbourhood_container, c::UInt128)
# end
#
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

function makestep(L::LifeCells, resize_ratio = 1.5)
    # initialize bag with the original size
    # bag = Vector{UInt128}(undef, length(L.bag))
    bag = Set{UInt64}()
    sizehint!(bag, length(L.bag))
    # bagsize = 0
    neighbourhood_container = Vector{UInt64}(undef, 8)
    neighbourhood_container2 = Vector{UInt64}(undef, 8)
    # big_neighbourhood_container = Vector{UInt128}(undef, 13)
    # neighbours_container = ContainerWithLength{UInt64}(13)

    for cell in L.bag
        neighbourhood!(neighbourhood_container, cell)
        # bigneighbourhood!(big_neighbourhood_container, cell)
        # neighbours!(neighbours_container, big_neighbourhood_container, L)
        cnt = 0
        for nb in neighbourhood_container
            # cnt += is_in_neighbours(neighbours_container, nb)
            cnt += nb in L.bag ? 1 : 0
        end
        if (cnt == 2) | (cnt == 3)
            push!(bag, cell)
            # bagsize += 1
            # # beggars push!
            # if bagsize > length(bag)
            #     resize!(bag, Int(ceil(length(bag)*resize_ratio)))
            # end
            # bag[bagsize] = cell
        end
        # we should also add newborn cells
        for nb in neighbourhood_container
            nb in L.bag && continue
            nb in bag && continue
            # is_in_neighbours(neighbours_container, nb) == 1 && continue
            neighbourhood!(neighbourhood_container2, nb)
            cnt = 0
            for nbb in neighbourhood_container2
                # cnt += is_in_neighbours(neighbours_container, nb)
                cnt += nbb in L.bag ? 1 : 0
            end
            if cnt == 3
                push!(bag, nb)
                # bagsize += 1
                # # beggars push!
                # if bagsize > length(bag)
                #     resize!(bag, Int(ceil(length(bag)*resize_ratio)))
                # end
                # bag[bagsize] = nb
            end
        end
    end

    # resize!(bag, bagsize)
    return LifeCells(bag)
end

function create_initial_state(n, m, density = 0.7, offset = 1_000_000)
    bag = Set{UInt64}()
    sizehint!(bag, Int(ceil(n*m*density)))
    for i in 1:n, j in 1:m
        if rand() <= density
            push!(bag, to_cell(i + offset, j + offset))
        end
    end

    LifeCells(bag)
end

end # module
