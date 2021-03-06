--[[
	Runs a function on every descendant from some main parent.
	Arguments:
		main : The main parent to find descendants of (note will also run on self).
                         Can also optionally be a table of instances, in which case all instances will be used as a base point.
		each : A function to be called for every descendant (provided check is true).
		check: [OPTIONAL] Determines whether or not to run the each function
		                 on a given descendant. If this returns false, will not run
		                 each. Defaults to always true.
	Returns: Nothing
--]]

return function (main, each, check)
	if (not check) then
		check = function() return true; end
	end

	if (typeof (main) ~= "table") then
		main = { main };
	end

	local parts = main;

	-- check & run function ...
	local _check = function (c)
		if (check (c)) then
			return (each (c) == false);
		end
		return false;
	end

	-- append children ...
	local _append = function (children)
		for _,child in pairs (children) do
			table.insert (parts, child);
		end
	end

	-- go through everything
	while (#parts > 0) do
		local cur = table.remove (parts, #parts);

		-- run the function
		if (_check (cur)) then
			return;
		end

		-- add all children to our list of things to check
		-- note, doing a pcall here juts in case of errors
		pcall (function () _append (cur:GetChildren()); end)
	end
end
