<?php

declare(strict_types=1);

namespace Tomchochola\PHPStanRules;

use PhpParser\Node;
use PhpParser\Node\FunctionLike;
use PHPStan\Analyser\Scope;
use PHPStan\Rules\Rule;

/**
 * @implements Rule<FunctionLike>
 */
class FunctionRequired implements Rule
{
    /**
     * Get node type.
     */
    public function getNodeType(): string
    {
        return FunctionLike::class;
    }

    /**
     * Process node.
     *
     * @return array<int, string>
     */
    public function processNode(Node $node, Scope $scope): array
    {
        $messages = [];

        foreach ($node->getParams() as $index => $param) {
            if ($param->type !== null) {
                continue;
            }

            $messages[] = \sprintf('Parameter #%d of function has no typehint.', 1 + $index);
        }

        if ($node->getReturnType() === null) {
            $messages[] = 'Function has no return typehint.';
        }

        if (! $node instanceof Node\Expr\Closure && ! $node instanceof Node\Expr\ArrowFunction) {
            if ($node->getDocComment() === null) {
                $messages[] = 'Function has no doc comment.';
            }
        }

        return $messages;
    }
}
