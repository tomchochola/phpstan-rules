<?php

declare(strict_types=1);

namespace Tomchochola\PHPStanRules;

use PhpParser\Node;
use PhpParser\Node\Stmt\Property;
use PHPStan\Analyser\Scope;
use PHPStan\Rules\Rule;

/**
 * @implements Rule<Property>
 */
class PropertyRequired implements Rule
{
    /**
     * Get node type.
     */
    public function getNodeType(): string
    {
        return Property::class;
    }

    /**
     * Process node.
     *
     * @return array<int, string>
     */
    public function processNode(Node $node, Scope $scope): array
    {
        $messages = [];

        if ($node->getDocComment() === null) {
            $messages[] = 'Property has no doc comment.';
        }

        return $messages;
    }
}
